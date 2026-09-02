/**
 * 用户模块控制器
 * 统一挂载 /api/user 路径，遵循 { code, msg, data } 响应规范
 *
 * 安全约定：
 * - 密码 / PIN 只存 bcrypt 哈希，任何接口不返回 password_hash / pin_hash
 * - 管理类接口由 adminRequired 兜底（前端隐藏入口只是体验层，权限以服务端为准）
 * - 删除为软删除（status -> disabled），保留数据可追溯
 */

const db = require('../../utils/db')
const { hashValue, verifyValue, signToken } = require('../../utils/auth')
const { success, error } = require('../../utils/response')
/* Phase 6.4.1：审计日志 helpers */
const { logLoginHistory } = require('../../middleware/auth')
const { addLog } = require('../../modules/cms/cmsOpsController')
/* Phase 6.3：模块权限单一真源 */
const perms = require('../../utils/perms')
const { ownsSubAccount } = require('../../middleware/auth')

/** Phase 6.3 新增的子账号 / 权限字段（追加到 SAFE_COLS 与 LIST_COLS，存量字段顺序不变） */
const SUB_COLS = 'parent_coach_id, is_sub_account, approval_status, module_perms, apply_reason'

/** 对外安全字段（绝不包含 password_hash / pin_hash / session_token） */
const SAFE_COLS = 'id, username, real_name, department, store_id, role, status, must_change_password, create_time, update_time, ' + SUB_COLS

/** 用户列表字段：SAFE_COLS + last_active（在线判定）+ device_count（session_token 非空=1，简化设备数判定）+ last_login（最近一次成功登录时间，来自 cms_login_history） */
const LIST_COLS = `id, username, real_name, department, store_id, role, status, must_change_password, create_time, update_time, last_active,
  ${SUB_COLS},
  (CASE WHEN session_token IS NULL OR session_token = '' THEN 0 ELSE 1 END) AS device_count,
  (SELECT MAX(lh.create_time) FROM cms_login_history lh WHERE lh.user_id = sys_user.id AND lh.status = 'success') AS last_login`

/** 新增用户 / 重置登录密码时的默认初始密码 */
const DEFAULT_PASSWORD = '123456'
/** 重置 PIN 时的默认 PIN */
const DEFAULT_PIN = '8888'
/** Phase 6.3：每位 Coach 最多可拥有的门店子账号数（已通过 + 待审核 合并计数） */
const MAX_SUB_ACCOUNTS = 2

/** 校验账号格式（允许字母数字及邮箱常用字符） */
function validUsername(u) {
  return /^[A-Za-z0-9._@-]{3,64}$/.test(u)
}

/**
 * Phase 6.4 R5：账号统一小写归一
 * 所有账号（username）存储与比较统一小写（对邮箱/字母数字/手机号均成立；real_name/department 不动）
 */
function normUsername(u) { return String(u == null ? '' : u).trim().toLowerCase() }
function validRole(r) { return ['admin', 'super_admin', 'coach', 'store', 'user'].includes(r) }
function validStatus(s) { return s === 'active' || s === 'disabled' }

/** Phase 6.3：门店子账号用户名——手机号 / 邮箱 / 自定义账号名 */
function validSubUsername(u) {
  const s = String(u || '')
  if (s.length > 64 || s.length < 3) return false
  // 纯数字（手机号，3-20 位）
  if (/^\d{3,20}$/.test(s)) return true
  // 邮箱格式
  if (/^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$/.test(s)) return true
  // 自定义账号名：字母开头，后续可为字母/数字/下划线/点/短横，3-20 位
  if (/^[A-Za-z][A-Za-z0-9_.-]{2,19}$/.test(s)) return true
  return false
}

/**
 * Phase 6.3：统计某 Coach 的子账号配额占用
 * 口径：已建子账号（含 disabled，停用仍占名额）+ 待审核申请
 */
async function subAccountQuota(coachId) {
  const a = await db.query(
    `SELECT COUNT(*) AS c FROM sys_user WHERE parent_coach_id = $1 AND is_sub_account = 1`,
    [parseInt(coachId, 10)]
  )
  const b = await db.query(
    `SELECT COUNT(*) AS c FROM sys_account_apply WHERE coach_id = $1 AND status = 'pending'`,
    [parseInt(coachId, 10)]
  )
  const owned = parseInt((a[0] || {}).c, 10) || 0
  const pending = parseInt((b[0] || {}).c, 10) || 0
  return { owned, pending, used: owned + pending, max: MAX_SUB_ACCOUNTS, remain: Math.max(0, MAX_SUB_ACCOUNTS - owned - pending) }
}

/** 在线判定（与 list 保持同一口径：last_active 距今 <10 分钟） */
function isOnline(lastActive) {
  if (!lastActive) return false
  const t = new Date(lastActive).getTime()
  return !isNaN(t) && t >= Date.now() - 10 * 60 * 1000
}

/** 批量解析 parent_coach_id → { id: {username, real_name} }，避免在主查询里引入 JOIN（零回归） */
async function resolveCoachNames(rows) {
  const ids = []
  rows.forEach(function (r) {
    const pid = parseInt(r.parent_coach_id, 10)
    if (pid && ids.indexOf(pid) < 0) ids.push(pid)
  })
  if (!ids.length) return {}
  const list = await db.query(
    `SELECT id, username, real_name FROM sys_user WHERE id IN (${ids.map(function (n) { return parseInt(n, 10) }).join(',')})`
  )
  const map = {}
  list.forEach(function (c) { map[String(c.id)] = { username: c.username, real_name: c.real_name } })
  return map
}

/**
 * POST /api/user/login 账号密码登录（公开）
 * 返回 Token 与用户基础信息
 */
async function login(req, res) {
  try {
    const { username, password } = req.body || {}
    if (!username || !password) {
      /* 审计：参数缺失也记录失败 */
      logLoginHistory(null, 'failure', 'missing_username', req).catch(function() {})
      return res.json(error('账号和密码不能为空'))
    }

    // Phase 6.4 R5：账号大小写不敏感——统一小写后查询（返回的 user.username 即库里存的小写值）
    const uname = normUsername(username)
    const user = await db.findOne('sys_user', { username: uname })

    if (!user || !verifyValue(password, user.password_hash)) {
      /* 审计：登录失败 */
      logLoginHistory(null, 'failure', 'password_wrong', req).catch(function() {})
      return res.json(error('账号或密码错误'))
    }
    if (user.status !== 'active') {
      /* 审计：账号已停用 */
      logLoginHistory(user, 'failure', 'account_disabled', req).catch(function() {})
      return res.json(error('账号已被停用，请联系管理员'))
    }

    const token = signToken({ id: user.id, username: user.username, role: user.role })
    /* 阶段14：单设备登录互斥——写入当前有效 token，旧设备 token 立即失效；同时记录登录活跃时间 */
    await db.query(
      `UPDATE sys_user SET session_token = $1, last_active = CURRENT_TIMESTAMP WHERE id = $2`,
      [token, user.id]
    )
    /* 审计：登录成功 */
    logLoginHistory(user, 'success', null, req).catch(function() {})
    return res.json(success({
      token,
      must_change_password: parseInt(user.must_change_password, 10) === 1,
      user: {
        id: user.id,
        username: user.username,
        real_name: user.real_name,
        department: user.department,
        store_id: user.store_id || null,
        role: user.role
      }
    }, '登录成功'))
  } catch (e) {
    return res.status(500).json(error('登录失败：' + e.message, 500))
  }
}

/**
 * GET /api/user/list 分页用户列表（管理员）
 * 支持 keyword（账号/姓名/部门模糊）、status（active/disabled）、online（online/offline）筛选
 * 每用户附带 online（last_active 距今 <10 分钟）与 device_count（session_token 非空=1/空=0）
 */
async function list(req, res) {
  try {
    const { page = 1, pageSize = 10, keyword = '', status, online, role, department } = req.query
    // ★ Phase 6.4.2 P0 修复：统一时间基准，避免 SQL CURRENT_TIMESTAMP 与 JS Date.now() 分歧
    const nowMs = Date.now()
    const cutoffMs = nowMs - 10 * 60 * 1000
    const cutoffISO = new Date(cutoffMs).toISOString()

    const cond = []
    const params = []
    let i = 1

    if (keyword) {
      cond.push(`(username ILIKE $${i} OR real_name ILIKE $${i} OR department ILIKE $${i})`)
      params.push(`%${keyword}%`)
      i++
    }
    if (status) {
      cond.push(`status = $${i}`)
      params.push(status)
      i++
    }
    if (role) {
      cond.push(`role = $${i}`)
      params.push(role)
      i++
    }
    if (department) {
      cond.push(`department ILIKE $${i}`)
      params.push(`%${department}%`)
      i++
    }
    if (online === 'online') {
      // ★ 使用预计算的 cutoffISO 参数，确保 SQL 筛选与 JS 判定使用同一时间基准
      cond.push(`last_active >= $${i}`)
      params.push(cutoffISO)
      i++
    } else if (online === 'offline') {
      cond.push(`(last_active IS NULL OR last_active < $${i})`)
      params.push(cutoffISO)
      i++
    }
    const where = cond.length ? ' WHERE ' + cond.join(' AND ') : ''

    const countRows = await db.query(`SELECT COUNT(*) AS total FROM sys_user${where}`, params)
    const total = parseInt(countRows[0].total, 10) || 0

    const limit = parseInt(pageSize, 10) || 10
    const offset = (parseInt(page, 10) - 1) * limit
    const rows = await db.query(
      `SELECT ${LIST_COLS} FROM sys_user${where} ORDER BY id DESC LIMIT $${i} OFFSET $${i + 1}`,
      params.concat([limit, offset])
    )

    // ★ 使用同一 cutoffMs，消除 Date.now() 二次取值导致的时间漂移
    /* Phase 6.3：附上级 Coach 名称与有效模块权限（不改主查询结构，避免 JOIN 引入回归） */
    const coachMap = await resolveCoachNames(rows)
    const list = rows.map(function (r) {
      let lastTs = 0
      if (r.last_active) {
        const t = new Date(r.last_active).getTime()
        if (!isNaN(t)) lastTs = t
      }
      const c = coachMap[String(r.parent_coach_id)] || null
      return Object.assign({}, r, {
        online: lastTs > 0 && lastTs >= cutoffMs,
        is_sub_account: parseInt(r.is_sub_account, 10) === 1 ? 1 : 0,
        parent_coach_username: c ? c.username : '',
        parent_coach_name: c ? (c.real_name || c.username) : '',
        module_perms: perms.parsePerms(r.module_perms),
        perms: perms.effectivePerms(r.role, r.module_perms)
      })
    })

    return res.json(success({ list, total, page: parseInt(page, 10), pageSize: limit }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/**
 * POST /api/user/add 新增用户（管理员）
 * 自动生成初始密码哈希；初始 PIN 默认为空（由管理员另行重置）
 */
async function add(req, res) {
  try {
    const { username, real_name = '', department = '', role = 'user', password, pin, module_perms, store_id } = req.body || {}
    // Phase 6.4 R5：统一小写存储
    const uname = normUsername(username)
    if (!uname) return res.json(error('账号不能为空'))
    if (!validUsername(uname)) return res.json(error('账号格式不正确（3-64位，仅字母数字和 @._-）'))
    if (!validRole(role)) return res.json(error('角色不合法'))
    // Phase 6.4 补充：所属门店必填
    if (!department || !String(department).trim()) return res.json(error('所属门店不能为空，请选择门店后再创建账号'))

    // Phase 2.1：store_id 校验（可选，若提供需存在于 sys_store）
    let normalizedStoreId = null
    if (store_id !== undefined && store_id !== null) {
      const sid = parseInt(store_id, 10)
      if (isNaN(sid)) return res.json(error('store_id 格式不合法'))
      const storeExist = await db.findOne('sys_store', { id: sid }, 'id')
      if (!storeExist) return res.json(error('指定的门店不存在'))
      normalizedStoreId = sid
    }

    // Phase 6.4 补充：coach 角色若开通薪资权限，必须提供 PIN
    if (role === 'coach' && module_perms && module_perms.salary === true) {
      if (!pin) return res.json(error('开通激励计算器权限时必须设置 PIN（4-6位数字）'))
      if (!/^\d{4,6}$/.test(String(pin).trim())) return res.json(error('PIN 必须为 4-6 位纯数字'))
    }

    const exist = await db.findOne('sys_user', { username: uname }, 'id')
    if (exist) return res.json(error('账号已存在'))

    // 权限序列化（写入 module_perms JSON 字符串，若无则 null）
    const rawPerms = (module_perms && typeof module_perms === 'object') ? perms.serializePerms(module_perms) : null

    // 注意：TCB executePGSql 对 INSERT...RETURNING 不返回 Rows，db.insert() 会返回 null，
    // 故插入后按唯一账号回查 id（不依赖 RETURNING）。
    const insertData = {
      username: uname,
      password_hash: hashValue(password || DEFAULT_PASSWORD),
      real_name: String(real_name),
      department: String(department),
      store_id: normalizedStoreId,
      role,
      status: 'active',
      must_change_password: 1
    }
    // PIN：仅当明确提供且格式正确时存入（bcrypt 哈希，不明文）
    if (pin && /^\d{4,6}$/.test(String(pin).trim())) {
      insertData.pin_hash = hashValue(String(pin).trim())
    }
    if (rawPerms) insertData.module_perms = rawPerms
    await db.insert('sys_user', insertData)
    const row = await db.findOne('sys_user', { username: uname }, 'id, must_change_password')
    // 新建 Coach 账号且未传自定义密码时，返回默认密码供管理员首次分发（仅此一次）
    const outData = { id: row ? row.id : null }
    if (role === 'coach' && (!password || !String(password).trim())) {
      outData.init_password = DEFAULT_PASSWORD
    }
    /* 审计：创建用户 */
    addLog(req.user.id, req.user.username, 'user_create', 'user', row ? row.id : 0, `创建账号「${uname}」(${role}/${department})`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(outData, '新增成功'))
  } catch (e) {
    return res.status(500).json(error('新增失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/update/:id 编辑用户基础信息（管理员）
 * 支持：姓名、部门、角色、状态、module_perms、pin、username（邮箱即账号名）
 */
async function update(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { username, real_name, department, store_id, role, status, module_perms, pin } = req.body || {}

    const data = {}

    // username 字段处理：允许修改（但必须唯一 + 小写归一）
    if (username !== undefined) {
      const norm = normUsername(username)
      if (!norm) return res.json(error('账号不能为空'))
      if (!validUsername(norm)) return res.json(error('账号格式不合法（3-64 位字母/数字/.@_-）'))
      // 检查唯一性：排除自身记录
      const exist = await db.query(
        `SELECT id FROM sys_user WHERE LOWER(username) = $1 AND id != $2 LIMIT 1`,
        [norm, id]
      )
      if (exist.length > 0) return res.json(error('该账号已被占用'))
      data.username = norm
    }
    if (real_name !== undefined) data.real_name = String(real_name)
    if (department !== undefined) data.department = String(department)
    // Phase 2.1: store_id 更新（可选）
    if (store_id !== undefined) {
      if (store_id === null || store_id === '') {
        data.store_id = null
      } else {
        const sid = parseInt(store_id, 10)
        if (isNaN(sid)) return res.json(error('store_id 格式不合法'))
        const storeExist = await db.findOne('sys_store', { id: sid }, 'id')
        if (!storeExist) return res.json(error('指定的门店不存在'))
        data.store_id = sid
      }
    }
    if (role !== undefined) {
      if (!validRole(role)) return res.json(error('角色不合法'))
      data.role = role
    }
    if (status !== undefined) {
      if (!validStatus(status)) return res.json(error('状态不合法'))
      data.status = status
    }
    // module_perms：序列化后写入
    if (module_perms !== undefined) {
      const raw = (module_perms && typeof module_perms === 'object') ? perms.serializePerms(module_perms) : null
      data.module_perms = raw
    }
    // pin：仅当明确提供且格式正确时更新 bcrypt 哈希
    if (pin !== undefined && pin !== null && pin !== '') {
      if (!/^\d{4,6}$/.test(String(pin).trim())) {
        return res.json(error('PIN 必须为 4-6 位纯数字'))
      }
      data.pin_hash = hashValue(String(pin).trim())
      data.must_change_password = 0
    }
    // 清空 PIN 字段：允许通过传空字符串移除
    if (pin === '') data.pin_hash = null

    if (!Object.keys(data).length) return res.json(error('没有需要更新的字段'))

    const sets = []
    const params = []
    let i = 1
    for (const k of Object.keys(data)) {
      sets.push(`${k} = $${i}`)
      params.push(data[k])
      i++
    }
    params.push(id)
    await db.query(`UPDATE sys_user SET ${sets.join(', ')}, update_time = CURRENT_TIMESTAMP WHERE id = $${i}`, params)
    /* 审计：更新用户 */
    addLog(req.user.id, req.user.username, 'user_update', 'user', id, `更新账号信息「${username || id}」`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(null, '更新成功'))
  } catch (e) {
    return res.status(500).json(error('更新失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/reset-password/:id 重置登录密码（管理员）
 * body.password 可选，缺省重置为默认初始密码
 */
async function resetPassword(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { password } = req.body || {}
    const pwd = (password && String(password).trim()) || DEFAULT_PASSWORD
    await db.query(
      `UPDATE sys_user SET password_hash = $1, must_change_password = 1, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [hashValue(pwd), id]
    )
    /* 审计：重置密码 */
    addLog(req.user.id, req.user.username, 'password_reset', 'user', id, `重置密码「${id}」${password ? '' : '（默认密码）'}`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(null, '密码已重置' + (password ? '' : `（默认 ${DEFAULT_PASSWORD}）`) + '，该用户下次登录需修改密码'))
  } catch (e) {
    return res.status(500).json(error('重置密码失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/reset-pin/:id 重置激励计算器 PIN（管理员）
 * body.pin 可选，缺省重置为默认 PIN；提供时校验 4-6 位纯数字
 */
async function resetPin(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { pin } = req.body || {}
    // Phase 6.4：若提供 PIN 必须满足 4-6 位纯数字
    if (pin !== undefined && pin !== null && pin !== '') {
      if (!/^\d{4,6}$/.test(String(pin).trim())) {
        return res.json(error('PIN 必须为 4-6 位纯数字'))
      }
    }
    const newPin = (pin && String(pin).trim()) || DEFAULT_PIN
    await db.query(
      `UPDATE sys_user SET pin_hash = $1, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [hashValue(newPin), id]
    )
    /* 审计：重置 PIN */
    addLog(req.user.id, req.user.username, 'pin_reset', 'user', id, `重置 PIN「${id}」${pin ? '' : '（默认PIN）'}`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(null, 'PIN 已重置' + (pin ? '' : `（默认 ${DEFAULT_PIN}）`)))
  } catch (e) {
    return res.status(500).json(error('重置 PIN 失败：' + e.message, 500))
  }
}

/**
 * DELETE /api/user/delete/:id 删除用户（管理员，软删除）
 * 仅标记 status=disabled，不物理删除
 */
async function remove(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    await db.query(
      `UPDATE sys_user SET status = 'disabled', update_time = CURRENT_TIMESTAMP WHERE id = $1`,
      [id]
    )
    /* 审计：停用用户 */
    addLog(req.user.id, req.user.username, 'user_disable', 'user', id, `停用账号「${id}」`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(null, '已停用该账号'))
  } catch (e) {
    return res.status(500).json(error('删除失败：' + e.message, 500))
  }
}

/**
 * POST /api/user/verify-pin 校验当前用户 PIN（登录用户）
 * 激励计算器入口鉴权：body.pin 与当前用户 pin_hash 比对
 */
async function verifyPin(req, res) {
  try {
    const { pin } = req.body || {}
    if (!pin) return res.json(error('请输入 PIN'))
    const user = await db.findOne('sys_user', { id: req.user.id }, 'id, pin_hash')
    if (!user) return res.status(401).json(error('用户不存在', 401))
    if (!user.pin_hash) return res.json(error('PIN 未设置，请联系管理员重置'))
    if (!verifyValue(pin, user.pin_hash)) return res.json(error('PIN 错误'))
    return res.json(success(null, '校验通过'))
  } catch (e) {
    return res.status(500).json(error('校验失败：' + e.message, 500))
  }
}

/**
 * POST /api/user/change-pin 修改本人激励计算器 PIN（登录用户）
 * body: { old_pin, new_pin }
 * - 校验旧 PIN；新 PIN 格式 4-6 位纯数字，且不得与旧 PIN 相同
 */
async function changePin(req, res) {
  try {
    const { old_pin, new_pin } = req.body || {}
    if (!old_pin || !new_pin) return res.json(error('请输入旧 PIN 和新 PIN'))
    if (!/^\d{4,6}$/.test(String(new_pin).trim())) return res.json(error('新 PIN 必须为 4-6 位纯数字'))
    const user = await db.findOne('sys_user', { id: req.user.id }, 'id, pin_hash')
    if (!user) return res.status(401).json(error('用户不存在', 401))
    if (!user.pin_hash) return res.json(error('当前未设置 PIN，请联系管理员重置后再自行修改'))
    if (!verifyValue(String(old_pin).trim(), user.pin_hash)) return res.json(error('旧 PIN 错误'))
    if (String(old_pin).trim() === String(new_pin).trim()) return res.json(error('新 PIN 不得与旧 PIN 相同'))
    await db.query(
      `UPDATE sys_user SET pin_hash = $1, must_change_password = 0, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [hashValue(String(new_pin).trim()), user.id]
    )
    return res.json(success(null, 'PIN 修改成功'))
  } catch (e) {
    return res.status(500).json(error('修改失败：' + e.message, 500))
  }
}

/**
 * POST /api/user/change-password 修改本人密码（登录用户）
 * body: { old_password, new_password }
 * - 校验旧密码；新密码长度 ≥ 6 且不得与旧密码相同
 * - 成功后清零 must_change_password（首次登录强制改密 / 管理员重置后强制改密均走此接口）
 */
async function changePassword(req, res) {
  try {
    const { old_password, new_password } = req.body || {}
    if (!old_password || !new_password) return res.json(error('请输入旧密码和新密码'))
    if (String(new_password).length < 6) return res.json(error('新密码至少 6 位'))
    if (String(new_password) === String(old_password)) return res.json(error('新密码不能与旧密码相同'))
    const user = await db.findOne('sys_user', { id: req.user.id }, 'id, password_hash')
    if (!user) return res.status(401).json(error('用户不存在', 401))
    if (!verifyValue(old_password, user.password_hash)) return res.json(error('旧密码不正确'))
    await db.query(
      `UPDATE sys_user SET password_hash = $1, must_change_password = 0, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [hashValue(new_password), user.id]
    )
    return res.json(success(null, '密码修改成功'))
  } catch (e) {
    return res.status(500).json(error('修改失败：' + e.message, 500))
  }
}

/**
 * GET /api/user/info 获取当前登录用户信息（登录用户）
 */
async function info(req, res) {
  try {
    const user = await db.findOne('sys_user', { id: req.user.id }, SAFE_COLS)
    if (!user) return res.status(401).json(error('用户不存在或已被删除', 401))

    /* Phase 6.3：补充上级 Coach、有效模块权限、子账号配额（既有字段一律保留，仅做追加） */
    const isSub = parseInt(user.is_sub_account, 10) === 1
    const out = Object.assign({}, user, {
      is_sub_account: isSub ? 1 : 0,
      module_perms: perms.parsePerms(user.module_perms),
      perms: perms.effectivePerms(user.role, user.module_perms),
      module_keys: perms.MODULE_KEYS,
      parent_coach_username: '',
      parent_coach_name: ''
    })
    if (user.parent_coach_id) {
      const c = await db.findOne('sys_user', { id: parseInt(user.parent_coach_id, 10) }, 'id, username, real_name')
      if (c) {
        out.parent_coach_username = c.username || ''
        out.parent_coach_name = c.real_name || c.username || ''
      }
    }
    /* Coach 本人：附带子账号配额，个人中心「我的门店账号」直接用 */
    if ((user.role === 'coach' || user.role === 'super_admin') && !isSub) {
      out.sub_quota = await subAccountQuota(user.id)
    }
    return res.json(success(out, '获取成功'))
  } catch (e) {
    return res.status(500).json(error('获取失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/update-role/:id 修改用户角色（super_admin 权限）
 * body: { role: 'super_admin' | 'coach' | 'store' | 'user' }
 */
async function updateRole(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { role } = req.body || {}
    if (!validRole(role)) return res.json(error('角色不合法（可选：admin/super_admin/coach/store/user）'))

    // 防呆：不能修改自己（避免 self-lockout）
    if (id === req.user.id) return res.json(error('不能修改自己的角色，请先用其他管理员账号操作'))

    await db.query(
      `UPDATE sys_user SET role = $1, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [role, id]
    )
    /* 审计：修改角色 */
    addLog(req.user.id, req.user.username, 'role_change', 'user', id, `修改角色「${id}」→ ${role}`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(null, '角色已更新为『' + role + '』'))
  } catch (e) {
    return res.status(500).json(error('更新角色失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/kick/:id 强制下线（管理员）
 * 清空 session_token（置空字符串，与任何真实 token 均不相等，旧 token 立即失效；NULL 放行语义不适用）
 */
async function kick(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    // 使用 db.update 而非 db.query，确保 UPDATE 语句正确执行
    const affected = await db.update('sys_user', { session_token: '', update_time: new Date() }, { id })
    if (affected === 0) {
      return res.json(error('用户不存在', 404))
    }
    /* 审计：踢下线 */
    addLog(req.user.id, req.user.username, 'user_kick', 'user', id, `强制下线「${id}」`)
      .catch(function(e) { console.warn('[audit-log] 操作日志写入失败:', e.message) })
    return res.json(success(null, '已强制下线，该用户需重新登录'))
  } catch (e) {
    return res.status(500).json(error('强制下线失败：' + e.message, 500))
  }
}

/* ============================================================
 * Phase 6.3｜Coach 门店子账号 + 权限体系
 * 分两组：
 *   A. Coach 侧（coachRequired）：申请、查看、启停、重置密码、踢下线、查看权限
 *   B. 管理员侧（adminRequired）：审核列表、通过、拒绝、配置权限
 * 所有 Coach 侧写操作均先过 ownsSubAccount()，跨 Coach 一律 403。
 * ============================================================ */

/**
 * POST /api/user/apply-subaccount 申请门店子账号（Coach）
 * body: { username, real_name, apply_reason }
 * - 用户名仅允许手机号（纯数字 3-20 位）、邮箱、或自定义账号名（字母开头 3-20 位）
 * - 配额：已建 + 待审核 合计 < 2，第 3 个直接拒绝
 * - 门店（department）自动继承申请 Coach，不接受前端传入
 */
async function applySubaccount(req, res) {
  try {
    const { username, real_name = '', apply_reason = '' } = req.body || {}
    // Phase 6.4 R5：统一小写存储与比较
    const uname = normUsername(username)
    if (!uname) return res.json(error('请填写子账号'))
    if (!validSubUsername(uname)) return res.json(error('账号格式不正确，请使用手机号（如 13800138000）、邮箱（如 name@example.com）或自定义账号名（如 hexiwangfujing）'))

    const coachId = parseInt(req.user.id, 10)
    const quota = await subAccountQuota(coachId)
    if (quota.used >= MAX_SUB_ACCOUNTS) {
      return res.json(error(
        `每位 Coach 最多 ${MAX_SUB_ACCOUNTS} 个门店子账号（已开通 ${quota.owned} 个、待审核 ${quota.pending} 个），如需调整请联系管理员`
      ))
    }

    const exist = await db.findOne('sys_user', { username: uname }, 'id')
    if (exist) return res.json(error('该账号已存在，请更换'))
    const dup = await db.findOne('sys_account_apply', { username: uname, status: 'pending' }, 'id')
    if (dup) return res.json(error('该账号已有待审核申请，请勿重复提交'))

    /* 门店 / Coach 信息全部由服务端从 req.coach 取（coachRequired 已注入），不信任前端 */
    const coach = req.coach || {}
    await db.insert('sys_account_apply', {
      coach_id: coachId,
      coach_username: coach.username || req.user.username || '',
      coach_name: coach.real_name || '',
      department: coach.department || '',
      username: uname,
      real_name: String(real_name).slice(0, 64),
      apply_reason: String(apply_reason).slice(0, 255),
      status: 'pending'
    })
    const row = await db.findOne('sys_account_apply', { username: uname, status: 'pending' }, 'id, create_time')
    const after = await subAccountQuota(coachId)
    return res.json(success({
      id: row ? row.id : null,
      username: uname,
      department: coach.department || '',
      status: 'pending',
      quota: after
    }, '申请已提交，等待管理员审核'))
  } catch (e) {
    return res.status(500).json(error('提交申请失败：' + e.message, 500))
  }
}

/**
 * GET /api/user/my-subaccounts 我的门店子账号 + 我的申请记录（Coach）
 * 严格按 parent_coach_id = 当前 Coach 过滤，看不到其它 Coach 的账号
 */
async function mySubaccounts(req, res) {
  try {
    const coachId = parseInt(req.user.id, 10)
    const subs = await db.query(
      `SELECT id, username, real_name, department, role, status, approval_status, module_perms, apply_reason,
              must_change_password, last_active, create_time,
              (CASE WHEN session_token IS NULL OR session_token = '' THEN 0 ELSE 1 END) AS device_count
       FROM sys_user
       WHERE parent_coach_id = $1 AND is_sub_account = 1
       ORDER BY id DESC`,
      [coachId]
    )
    const applies = await db.query(
      `SELECT id, username, real_name, department, apply_reason, status, reject_reason,
              reviewer_name, review_time, create_time, created_user_id
       FROM sys_account_apply
       WHERE coach_id = $1
       ORDER BY id DESC
       LIMIT 50`,
      [coachId]
    )
    const list = subs.map(function (r) {
      return Object.assign({}, r, {
        online: isOnline(r.last_active),
        module_perms: perms.parsePerms(r.module_perms),
        perms: perms.effectivePerms(r.role, r.module_perms)
      })
    })
    return res.json(success({
      list,
      applies,
      quota: await subAccountQuota(coachId),
      module_keys: perms.MODULE_KEYS,
      module_labels: perms.MODULE_LABELS
    }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/subaccount/:id/status 启用 / 停用我的子账号（Coach）
 * body: { status: 'active' | 'disabled' }
 * 越权（非本人子账号 / 非子账号 / 不存在）统一 403，不泄漏账号是否存在
 */
async function updateSubStatus(req, res) {
  try {
    const { status } = req.body || {}
    if (!validStatus(status)) return res.json(error('状态不合法（可选：active / disabled）'))
    const row = await ownsSubAccount(req, req.params.id)
    if (!row) return res.status(403).json(error('无权操作该账号（仅可管理自己名下的门店子账号）', 403))

    const data = { status: status, update_time: new Date() }
    /* 停用同时清空 session_token，立即踢下线，避免停用后旧 token 仍可用 */
    if (status === 'disabled') data.session_token = ''
    await db.update('sys_user', data, { id: row.id })
    return res.json(success({ id: row.id, status }, status === 'active' ? '已启用该子账号' : '已停用该子账号并强制下线'))
  } catch (e) {
    return res.status(500).json(error('操作失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/subaccount/:id/reset-password 重置我的子账号密码（Coach）
 * body.password 可选，缺省用默认初始密码；重置后强制该子账号下次登录改密
 */
async function resetSubPassword(req, res) {
  try {
    const row = await ownsSubAccount(req, req.params.id)
    if (!row) return res.status(403).json(error('无权操作该账号（仅可管理自己名下的门店子账号）', 403))
    const { password } = req.body || {}
    const pwd = (password && String(password).trim()) || DEFAULT_PASSWORD
    if (pwd.length < 6) return res.json(error('密码至少 6 位'))
    await db.query(
      `UPDATE sys_user SET password_hash = $1, must_change_password = 1, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [hashValue(pwd), row.id]
    )
    return res.json(success({ id: row.id, init_password: password ? undefined : DEFAULT_PASSWORD },
      '密码已重置' + (password ? '' : `（默认 ${DEFAULT_PASSWORD}）`) + '，该子账号下次登录需修改密码'))
  } catch (e) {
    return res.status(500).json(error('重置密码失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/subaccount/:id/kick 强制我的子账号下线（Coach）
 * 与管理员 kick 同语义：session_token 置空字符串，旧 token 立即失效
 */
async function kickSubaccount(req, res) {
  try {
    const row = await ownsSubAccount(req, req.params.id)
    if (!row) return res.status(403).json(error('无权操作该账号（仅可管理自己名下的门店子账号）', 403))
    await db.update('sys_user', { session_token: '', update_time: new Date() }, { id: row.id })
    return res.json(success({ id: row.id }, '已强制下线，该子账号需重新登录'))
  } catch (e) {
    return res.status(500).json(error('强制下线失败：' + e.message, 500))
  }
}

/**
 * GET /api/user/subaccount/:id/permissions 查看我的子账号权限（Coach，只读）
 * Coach 只能看，不能改；改权限是管理员职责
 */
async function getSubPermissions(req, res) {
  try {
    const row = await ownsSubAccount(req, req.params.id)
    if (!row) return res.status(403).json(error('无权查看该账号（仅可管理自己名下的门店子账号）', 403))
    return res.json(success({
      id: row.id,
      username: row.username,
      role: row.role,
      module_perms: perms.parsePerms(row.module_perms),
      perms: perms.effectivePerms(row.role, row.module_perms),
      module_keys: perms.MODULE_KEYS,
      module_labels: perms.MODULE_LABELS,
      editable: false,
      hint: '权限调整请联系管理员'
    }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/**
 * GET /api/user/applications 子账号申请列表（管理员）
 * query: status=pending|approved|rejected|all, keyword, page, pageSize
 * 附各状态计数，供「账号申请」Tab 角标使用
 */
async function listApplications(req, res) {
  try {
    const { page = 1, pageSize = 20, keyword = '', status = 'pending' } = req.query
    const cond = []
    const params = []
    let i = 1
    if (status && status !== 'all') {
      cond.push(`status = $${i}`); params.push(String(status)); i++
    }
    if (keyword) {
      cond.push(`(username ILIKE $${i} OR real_name ILIKE $${i} OR department ILIKE $${i} OR coach_name ILIKE $${i} OR coach_username ILIKE $${i})`)
      params.push(`%${keyword}%`); i++
    }
    const where = cond.length ? ' WHERE ' + cond.join(' AND ') : ''

    const countRows = await db.query(`SELECT COUNT(*) AS total FROM sys_account_apply${where}`, params)
    const total = parseInt((countRows[0] || {}).total, 10) || 0

    const limit = parseInt(pageSize, 10) || 20
    const offset = (parseInt(page, 10) - 1) * limit
    const rows = await db.query(
      `SELECT id, coach_id, coach_username, coach_name, department, username, real_name, apply_reason,
              status, reject_reason, reviewer_id, reviewer_name, review_time, created_user_id, create_time
       FROM sys_account_apply${where}
       ORDER BY (CASE WHEN status = 'pending' THEN 0 ELSE 1 END), id DESC
       LIMIT $${i} OFFSET $${i + 1}`,
      params.concat([limit, offset])
    )

    const cntRows = await db.query(`SELECT status, COUNT(*) AS c FROM sys_account_apply GROUP BY status`)
    const counts = { pending: 0, approved: 0, rejected: 0 }
    cntRows.forEach(function (r) { counts[r.status] = parseInt(r.c, 10) || 0 })

    return res.json(success({ list: rows, total, counts, page: parseInt(page, 10), pageSize: limit }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/application/:id/approve 通过申请并创建门店子账号（管理员）
 * body.password 可选（缺省默认初始密码）
 * 创建的账号：role=store, is_sub_account=1, approval_status=approved,
 *            parent_coach_id / department 继承申请单，module_perms 写入默认权限
 */
async function approveApplication(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const apply = await db.findOne('sys_account_apply', { id })
    if (!apply) return res.json(error('申请不存在'))
    if (apply.status !== 'pending') return res.json(error('该申请已处理（当前状态：' + apply.status + '）'))

    /* 审核时二次校验：账号唯一 + 配额未被其它已通过申请占满（Phase 6.4 R5：统一小写比较） */
    const normName = normUsername(apply.username)
    const exist = await db.findOne('sys_user', { username: normName }, 'id')
    if (exist) return res.json(error('账号「' + apply.username + '」已存在，无法创建，请驳回该申请'))
    const quota = await subAccountQuota(apply.coach_id)
    if (quota.owned >= MAX_SUB_ACCOUNTS) {
      return res.json(error(`该 Coach 名下已有 ${quota.owned} 个子账号，达到上限 ${MAX_SUB_ACCOUNTS} 个，无法再通过`))
    }

    const { password } = req.body || {}
    const pwd = (password && String(password).trim()) || DEFAULT_PASSWORD
    if (pwd.length < 6) return res.json(error('初始密码至少 6 位'))

    await db.insert('sys_user', {
      username: normName,
      password_hash: hashValue(pwd),
      real_name: apply.real_name || '',
      department: apply.department || '',
      role: 'store',
      status: 'active',
      must_change_password: 1,
      parent_coach_id: parseInt(apply.coach_id, 10),
      is_sub_account: 1,
      approval_status: 'approved',
      /* JSONB 列必须传 JSON 字符串：db.esc 对对象会退化成 [object Object] */
      module_perms: perms.serializePerms(null),
      apply_reason: apply.apply_reason || ''
    })
    const created = await db.findOne('sys_user', { username: normName }, 'id')

    const me = await db.findOne('sys_user', { id: req.user.id }, 'username, real_name')
    const reviewerName = (me && (me.real_name || me.username)) || req.user.username || ''
    await db.query(
      `UPDATE sys_account_apply
       SET status = 'approved', reviewer_id = $1, reviewer_name = $2, review_time = CURRENT_TIMESTAMP,
           created_user_id = $3, reject_reason = '', update_time = CURRENT_TIMESTAMP
       WHERE id = $4`,
      [parseInt(req.user.id, 10), reviewerName, created ? parseInt(created.id, 10) : null, id]
    )

    return res.json(success({
      apply_id: id,
      user_id: created ? created.id : null,
      username: normName,
      department: apply.department || '',
      parent_coach_id: apply.coach_id,
      init_password: pwd,
      module_perms: perms.normalizePerms(null)
    }, '已通过申请并创建门店子账号（默认开通 AEP 周任务 + 月考模式）'))
  } catch (e) {
    return res.status(500).json(error('审核失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/application/:id/reject 驳回申请（管理员）
 * body: { reject_reason }
 */
async function rejectApplication(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const apply = await db.findOne('sys_account_apply', { id }, 'id, status')
    if (!apply) return res.json(error('申请不存在'))
    if (apply.status !== 'pending') return res.json(error('该申请已处理（当前状态：' + apply.status + '）'))

    const { reject_reason = '' } = req.body || {}
    const me = await db.findOne('sys_user', { id: req.user.id }, 'username, real_name')
    const reviewerName = (me && (me.real_name || me.username)) || req.user.username || ''
    await db.query(
      `UPDATE sys_account_apply
       SET status = 'rejected', reject_reason = $1, reviewer_id = $2, reviewer_name = $3,
           review_time = CURRENT_TIMESTAMP, update_time = CURRENT_TIMESTAMP
       WHERE id = $4`,
      [String(reject_reason).slice(0, 255), parseInt(req.user.id, 10), reviewerName, id]
    )
    return res.json(success({ apply_id: id, status: 'rejected' }, '已驳回该申请'))
  } catch (e) {
    return res.status(500).json(error('驳回失败：' + e.message, 500))
  }
}

/**
 * PUT /api/user/subaccount/:id/permissions 配置账号模块权限（管理员）
 * body: { module_perms: { script, demo, exam, aep, hours, salary } }
 * 说明：仅 role=store 的账号受权限约束；对其它角色写入不报错但不生效（返回提示）
 */
async function updateSubPermissions(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { module_perms } = req.body || {}
    if (!module_perms || typeof module_perms !== 'object' || Array.isArray(module_perms)) {
      return res.json(error('参数错误：module_perms 需为对象，如 {"aep":true,"exam":true}'))
    }
    const target = await db.findOne('sys_user', { id }, 'id, username, role, is_sub_account')
    if (!target) return res.json(error('用户不存在'))

    const normalized = perms.normalizePerms(module_perms)
    await db.query(
      `UPDATE sys_user SET module_perms = $1, update_time = CURRENT_TIMESTAMP WHERE id = $2`,
      [JSON.stringify(normalized), id]
    )
    const restricted = perms.UNRESTRICTED_ROLES.indexOf(target.role) < 0
    return res.json(success({
      id,
      username: target.username,
      role: target.role,
      module_perms: normalized,
      effective: restricted
    }, restricted ? '权限已更新' : '权限已保存，但该角色（' + target.role + '）默认全模块开放，权限配置暂不生效'))
  } catch (e) {
    return res.status(500).json(error('更新权限失败：' + e.message, 500))
  }
}

module.exports = {
  login, list, add, update, resetPassword, resetPin, remove, verifyPin, changePassword, changePin, info, updateRole, kick,
  /* Phase 6.3｜Coach 侧 */
  applySubaccount, mySubaccounts, updateSubStatus, resetSubPassword, kickSubaccount, getSubPermissions,
  /* Phase 6.3｜管理员侧 */
  listApplications, approveApplication, rejectApplication, updateSubPermissions
}
