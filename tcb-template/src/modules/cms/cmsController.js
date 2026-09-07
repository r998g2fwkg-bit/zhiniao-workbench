/**
 * 内容管理模块控制器（阶段9）
 * 统一挂载 /api/cms：话术（script）+ 演示（demo）内容管理
 *
 * 权限：
 * - 登录用户（authRequired）：list / detail —— 普通用户仅返回 published；管理员可筛选全部
 * - 管理员（adminRequired）：add / update / toggle-status / delete
 *
 * 响应统一 { code, msg, data }；返回原始表字段（category/sub_category/title/content/tags/status...），
 * 前端按既有数据结构做兼容映射，用户端渲染逻辑零修改。
 */

const db = require('../../utils/db')
const { success, error } = require('../../utils/response')
const ops = require('./cmsOpsController')

const SCRIPT_COLS = 'id, category, sub_category, title, content, tags, rounds, status, sort, creator_id, create_time, update_time, on_shelf_time, department, store_id, is_deleted'
const DEMO_COLS = 'id, category, title, description, content, status, sort, creator_id, create_time, update_time, department, store_id, is_deleted'

/* 话术 content 分隔结构（与迁移/前端约定一致） */
const Q_TAG = '【顾客问题】'
const A_TAG = '【Coach 推荐话术】'
function splitContent(content) {
  const s = String(content || '')
  let q = '', a = ''
  const qi = s.indexOf(Q_TAG), ai = s.indexOf(A_TAG)
  if (qi >= 0 && ai > qi) { q = s.slice(qi + Q_TAG.length, ai).trim(); a = s.slice(ai + A_TAG.length).trim(); }
  else if (qi >= 0) { q = s.slice(qi + Q_TAG.length).trim(); }
  else q = s.trim()
  return { q, a }
}
function joinContent(q, a) { return Q_TAG + '\n' + (q || '') + '\n\n' + A_TAG + '\n' + (a || '') }
/** 解析并校验 rounds 数组（[{question,answer,keywords}]） */
function parseRounds(input) {
  if (!Array.isArray(input) || !input.length) return null
  const arr = input.map((r) => ({ question: String((r && r.question) || '').trim(), answer: String((r && r.answer) || '').trim(), keywords: String((r && r.keywords) || '') }))
  if (!arr[0].question || !arr[0].answer) return null
  return arr
}

/* ============ 通用分页列表 ============ */
/**
 * GET /api/cms/categories 分类树（登录用户）
 * 两套分类分区，互不混杂：
 * - sheets（话术分区）：cms_script 的 category + sub_category 聚合
 * - demos（演示分区）：cms_demo 的 category 聚合；二级分类存于 content JSON 的 category 字段
 * 返回 { sheets: [{ name, subs: [...] }], demos: [{ name, subs: [...] }] }
 * 供「新增话术 / 新增演示」弹窗的一级 + 二级联动下拉使用；前端接口失败时回退本地静态分类。
 */
async function categories(req, res) {
  try {
    const scriptRows = await db.query(
      `SELECT DISTINCT category, sub_category FROM cms_script WHERE category IS NOT NULL AND category <> '' AND is_deleted = FALSE ORDER BY category, sub_category`
    )
    const demoRows = await db.query(
      `SELECT category, content FROM cms_demo WHERE category IS NOT NULL AND category <> '' AND is_deleted = FALSE ORDER BY category`
    )
    const sheetMap = {}
    scriptRows.forEach(function (r) {
      const name = String(r.category)
      if (!sheetMap[name]) sheetMap[name] = { name: name, subs: [] }
      const sub = String(r.sub_category || '').trim()
      if (sub && sheetMap[name].subs.indexOf(sub) < 0) sheetMap[name].subs.push(sub)
    })
    const demoMap = {}
    demoRows.forEach(function (r) {
      const name = String(r.category)
      if (!demoMap[name]) demoMap[name] = { name: name, subs: [] }
      let sub = ''
      try {
        const parsed = JSON.parse(r.content || '{}')
        sub = String((parsed && parsed.category) || '').trim()
      } catch (e) { sub = '' }
      if (sub && demoMap[name].subs.indexOf(sub) < 0) demoMap[name].subs.push(sub)
    })
    const sheets = Object.keys(sheetMap).sort().map(function (k) { return sheetMap[k] })
    const demos = Object.keys(demoMap).sort().map(function (k) { return demoMap[k] })
    return res.json(success({ sheets, demos }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/* ============ 通用分页列表 ============ */
/**
 * 内容分页列表核心逻辑（话术/演示共用）
 * @param {string} table  - 表名
 * @param {string} cols   - 返回字段
 * @param {string[]} likeCols - 关键词模糊匹配字段
 * @param {boolean} requireDepartment - 是否要求部门过滤（阶段13）
 */
function buildList(table, cols, likeCols, requireDepartment = false) {
  return async function (req, res) {
    try {
      const { category = '', status = '', keyword = '', page = 1, pageSize = 10, department, sub_category = '', createStart = '', createEnd = '', sort = '', order = '', store_id } = req.query
      const isAdmin = req.user && (req.user.role === 'admin' || req.user.role === 'super_admin')
      const cond = []
      const params = []
      let i = 1

      // Phase 2.2: store_id 过滤（管理员可筛选，普通用户按 store_id 隔离）
      if (store_id !== undefined && store_id !== '') {
        const sid = parseInt(store_id, 10)
        if (!isNaN(sid)) {
          if (!isAdmin) {
            // 普通用户：仅可见本部门或全局内容
            const userStoreId = req.user.store_id
            if (userStoreId) {
              cond.push(`(store_id = $${i} OR store_id IS NULL OR store_id = 0)`)
              params.push(sid)
              i++
            }
          } else {
            // 管理员：精确筛选
            cond.push(`store_id = $${i}`)
            params.push(sid)
            i++
          }
        }
      }

      // 阶段13：部门数据隔离
      if (requireDepartment && !isAdmin) {
        const userDept = req.user.department
        if (userDept) {
          cond.push(`(department = $${i} OR department IS NULL OR department = '')`)
          params.push(userDept)
          i++
        }
      }

      /* P0 修复：所有 list 查询强制过滤已删除记录 */
      cond.push(`is_deleted = FALSE`)

      if (!isAdmin) {
        cond.push(`status = 'published'`)
      } else if (status) {
        cond.push(`status = $${i}`)
        params.push(status)
        i++
      }
      if (category) {
        cond.push(`category = $${i}`)
        params.push(category)
        i++
      }
      if (keyword) {
        const like = likeCols.map((c) => `${c} ILIKE $${i}`).join(' OR ')
        cond.push(`(${like})`)
        params.push(`%${keyword}%`)
        i++
      }
      if (sub_category) {
        cond.push(`sub_category = $${i}`)
        params.push(sub_category)
        i++
      }
      if (createStart) {
        cond.push(`create_time >= $${i}`)
        params.push(createStart)
        i++
      }
      if (createEnd) {
        cond.push(`create_time <= $${i}`)
        params.push(createEnd)
        i++
      }
      const where = cond.length ? ' WHERE ' + cond.join(' AND ') : ''

      const countRows = await db.query(`SELECT COUNT(*) AS total FROM ${table}${where}`, params)
      const total = parseInt(countRows[0].total, 10) || 0
      const limit = parseInt(pageSize, 10) || 10
      const offset = (parseInt(page, 10) - 1) * limit
      // V3.2：真实排序（白名单防注入）；轮次按 json_array_length 实际轮数；无 sort 参数时保持原 manual sort 默认
      const SORT_WHITELIST = {
        id: 'id',
        title: 'title',
        create_time: 'create_time',
        status: 'status',
        rounds: "json_array_length(COALESCE(NULLIF(rounds,''),'[]')::json)"
      }
      let orderBy
      if (SORT_WHITELIST[sort]) {
        const dir = (order === 'asc') ? 'ASC' : 'DESC'
        if (sort === 'id') orderBy = `id ${dir}`
        else if (sort === 'rounds') orderBy = `json_array_length(COALESCE(NULLIF(rounds,''),'[]')::json) ${dir}, id DESC`
        else orderBy = `${SORT_WHITELIST[sort]} ${dir}, id DESC`
      } else {
        orderBy = 'sort ASC, id ASC'
      }
      const rows = await db.query(
        `SELECT ${cols} FROM ${table}${where} ORDER BY ${orderBy} LIMIT $${i} OFFSET $${i + 1}`,
        params.concat([limit, offset])
      )
      return res.json(success({ list: rows, total, page: parseInt(page, 10), pageSize: limit }, '查询成功'))
    } catch (e) {
      return res.status(500).json(error('查询失败：' + e.message, 500))
    }
  }
}

/** 详情（普通用户仅可查看 published；P0：所有人不能查看已删除内容） */
function buildDetail(table, cols) {
  return async function (req, res) {
    try {
      const id = parseInt(req.params.id, 10)
      if (!id) return res.json(error('参数错误'))
      const row = await db.findOne(table, { id }, cols)
      if (!row) return res.json(error('内容不存在', 404))
      if (row.is_deleted === true) return res.json(error('内容不存在', 404))
      if (req.user.role !== 'admin' && req.user.role !== 'super_admin' && row.status !== 'published') return res.json(error('内容不存在', 404))
      return res.json(success(row, '查询成功'))
    } catch (e) {
      return res.status(500).json(error('查询失败：' + e.message, 500))
    }
  }
}

/* ============ 话术 cms_script ============ */
// 阶段13：启用部门数据隔离（非管理员仅见本部门内容）
const scriptList = buildList('cms_script', SCRIPT_COLS, ['title', 'content', 'tags', 'rounds', 'category'], false)
const scriptDetail = buildDetail('cms_script', SCRIPT_COLS)

async function scriptAdd(req, res) {
  try {
    const { category, sub_category = '', title, rounds, tags = '', status = 'published', sort = 0, department = '', store_id } = req.body || {}
    if (!category || !title) return res.json(error('分类、标题不能为空'))
    if (!['published', 'draft'].includes(status)) return res.json(error('状态不合法'))
    const roundsArr = parseRounds(rounds)
    if (!roundsArr) return res.json(error('至少需要一轮完整问答（问题+回答）'))
    const first = roundsArr[0]
    const insertData = {
      category: String(category), sub_category: String(sub_category), title: String(title),
      content: joinContent(first.question, first.answer),
      tags: first.keywords || String(tags),
      rounds: JSON.stringify(roundsArr),
      status, sort: parseInt(sort, 10) || 0,
      department: String(department),
      store_id: store_id !== undefined ? (store_id ? parseInt(store_id, 10) : null) : null,
      creator_id: req.user.id
    }
    // 首次发布（status=published）时写入 on_shelf_time；草稿不写
    if (status === 'published') insertData.on_shelf_time = new Date()
    await db.insert('cms_script', insertData)
    ops.addLog(req.user.id, req.user.username, 'add', 'script', 0, `新增话术「${String(title)}」`)
    return res.json(success(null, '新增成功'))
  } catch (e) {
    return res.status(500).json(error('新增失败：' + e.message, 500))
  }
}

async function scriptUpdate(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { category, sub_category, title, rounds, tags, status, sort, department, store_id } = req.body || {}
    const data = {}
    if (category !== undefined) { if (!category) return res.json(error('分类不能为空')); data.category = String(category) }
    if (sub_category !== undefined) data.sub_category = String(sub_category)
    if (title !== undefined) { if (!title) return res.json(error('标题不能为空')); data.title = String(title) }
    if (rounds !== undefined) {
      const roundsArr = parseRounds(rounds)
      if (!roundsArr) return res.json(error('至少需要一轮完整问答（问题+回答）'))
      data.rounds = JSON.stringify(roundsArr)
      data.content = joinContent(roundsArr[0].question, roundsArr[0].answer)
      data.tags = roundsArr[0].keywords || ''
    }
    if (tags !== undefined && rounds === undefined) data.tags = String(tags)
    if (status !== undefined) { if (!['published', 'draft'].includes(status)) return res.json(error('状态不合法')); data.status = status }
    if (sort !== undefined) data.sort = parseInt(sort, 10) || 0
    if (department !== undefined) data.department = String(department)
    // Phase 2.2: store_id 更新
    if (store_id !== undefined) {
      data.store_id = store_id ? parseInt(store_id, 10) : null
    }
    if (!Object.keys(data).length) return res.json(error('没有需要更新的字段'))
    const prev = await db.findOne('cms_script', { id }, '*')
    await updateRow('cms_script', data, id)
    if (prev) await ops.saveVersion('script', id, ops.pickSnapshot('script', prev), req.user.id)
    ops.addLog(req.user.id, req.user.username, 'update', 'script', id, `编辑话术「${prev ? prev.title : id}」`)
    return res.json(success(null, '更新成功'))
  } catch (e) {
    return res.status(500).json(error('更新失败：' + e.message, 500))
  }
}

/** 切换上下架：published <-> draft */
function toggleStatus(table, targetType) {
  return async function (req, res) {
    try {
      const id = parseInt(req.params.id, 10)
      if (!id) return res.json(error('参数错误'))
      const row = await db.findOne(table, { id }, 'id, title, status')
      if (!row) return res.json(error('内容不存在'))
      const next = row.status === 'published' ? 'draft' : 'published'
      // 从 draft 变为 published 时，更新 on_shelf_time（记录最近一次上架时间）
      const onShelfSet = next === 'published' ? ', on_shelf_time = CURRENT_TIMESTAMP' : ''
      await db.query(
        `UPDATE ${table} SET status = $1, update_time = CURRENT_TIMESTAMP${onShelfSet} WHERE id = $2`,
        [next, id]
      )
      ops.addLog(req.user.id, req.user.username, 'toggle', targetType, id, `${targetType === 'script' ? '话术' : '演示'}「${row.title}」${next === 'published' ? '上架' : '下架'}`)
      return res.json(success(null, next === 'published' ? '已上架' : '已下架'))
    } catch (e) {
      return res.status(500).json(error('操作失败：' + e.message, 500))
    }
  }
}
const scriptToggleStatus = toggleStatus('cms_script', 'script')
const demoToggleStatus = toggleStatus('cms_demo', 'demo')

async function scriptDelete(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const row = await db.findOne('cms_script', { id }, 'id, title, is_deleted')
    if (!row) return res.json(error('内容不存在'))
    if (row.is_deleted === true) return res.json(error('内容已删除'))
    /* P0 修复：软删除（is_deleted=TRUE），不再物理 DELETE */
    await db.query(
      `UPDATE cms_script SET is_deleted = TRUE, status = 'draft', update_time = CURRENT_TIMESTAMP WHERE id = $1`,
      [id]
    )
    ops.addLog(req.user.id, req.user.username, 'delete', 'script', id, `删除话术「${row.title}」`)
    return res.json(success(null, '已删除'))
  } catch (e) {
    return res.status(500).json(error('删除失败：' + e.message, 500))
  }
}

/* ============ 演示 cms_demo ============ */
// 阶段13：启用部门数据隔离
const demoList = buildList('cms_demo', DEMO_COLS, ['title', 'description', 'content', 'category'], false)
const demoDetail = buildDetail('cms_demo', DEMO_COLS)

async function demoAdd(req, res) {
  try {
    const { category, title, description = '', content, status = 'published', sort = 0, department = '', store_id } = req.body || {}
    if (!category || !title || !content) return res.json(error('分类、标题、内容不能为空'))
    if (!['published', 'draft'].includes(status)) return res.json(error('状态不合法'))
    await db.insert('cms_demo', {
      category: String(category), title: String(title), description: String(description),
      content: String(content), status, sort: parseInt(sort, 10) || 0,
      department: String(department),
      store_id: store_id !== undefined ? (store_id ? parseInt(store_id, 10) : null) : null,
      creator_id: req.user.id
    })
    ops.addLog(req.user.id, req.user.username, 'add', 'demo', 0, `新增演示「${String(title)}」`)
    return res.json(success(null, '新增成功'))
  } catch (e) {
    return res.status(500).json(error('新增失败：' + e.message, 500))
  }
}

async function demoUpdate(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const { category, title, description, content, status, sort, department, store_id } = req.body || {}
    const data = {}
    if (category !== undefined) { if (!category) return res.json(error('分类不能为空')); data.category = String(category) }
    if (title !== undefined) { if (!title) return res.json(error('标题不能为空')); data.title = String(title) }
    if (description !== undefined) data.description = String(description)
    if (content !== undefined) { if (!content) return res.json(error('内容不能为空')); data.content = String(content) }
    if (status !== undefined) { if (!['published', 'draft'].includes(status)) return res.json(error('状态不合法')); data.status = status }
    if (sort !== undefined) data.sort = parseInt(sort, 10) || 0
    if (department !== undefined) data.department = String(department)
    // Phase 2.2: store_id 更新
    if (store_id !== undefined) {
      data.store_id = store_id ? parseInt(store_id, 10) : null
    }
    if (!Object.keys(data).length) return res.json(error('没有需要更新的字段'))
    const prev = await db.findOne('cms_demo', { id }, '*')
    await updateRow('cms_demo', data, id)
    if (prev) await ops.saveVersion('demo', id, ops.pickSnapshot('demo', prev), req.user.id)
    ops.addLog(req.user.id, req.user.username, 'update', 'demo', id, `编辑演示「${prev ? prev.title : id}」`)
    return res.json(success(null, '更新成功'))
  } catch (e) {
    return res.status(500).json(error('更新失败：' + e.message, 500))
  }
}

async function demoDelete(req, res) {
  try {
    const id = parseInt(req.params.id, 10)
    if (!id) return res.json(error('参数错误'))
    const row = await db.findOne('cms_demo', { id }, 'id, title, is_deleted')
    if (!row) return res.json(error('内容不存在'))
    if (row.is_deleted === true) return res.json(error('内容已删除'))
    /* P0 修复：软删除（is_deleted=TRUE），不再物理 DELETE */
    await db.query(
      `UPDATE cms_demo SET is_deleted = TRUE, status = 'draft', update_time = CURRENT_TIMESTAMP WHERE id = $1`,
      [id]
    )
    ops.addLog(req.user.id, req.user.username, 'delete', 'demo', id, `删除演示「${row.title}」`)
    return res.json(success(null, '已删除'))
  } catch (e) {
    return res.status(500).json(error('删除失败：' + e.message, 500))
  }
}

/** 通用更新（动态字段 + update_time 刷新） */
async function updateRow(table, data, id) {
  const sets = []
  const params = []
  let i = 1
  for (const k of Object.keys(data)) {
    sets.push(`${k} = $${i}`)
    params.push(data[k])
    i++
  }
  params.push(id)
  await db.query(`UPDATE ${table} SET ${sets.join(', ')}, update_time = CURRENT_TIMESTAMP WHERE id = $${i}`, params)
}

/** 数据看板统计（已登录用户可见，不限管理员） */
async function stats(req, res) {
  try {
    /* P0 修复：统计时排除已删除记录 */
    const s = await db.query(
      `SELECT COUNT(*) AS total, COUNT(*) FILTER (WHERE status = 'published') AS published, COUNT(*) FILTER (WHERE status = 'draft') AS draft FROM cms_script WHERE is_deleted = FALSE`
    )
    const d = await db.query(
      `SELECT COUNT(*) AS total, COUNT(*) FILTER (WHERE status = 'published') AS published, COUNT(*) FILTER (WHERE status = 'draft') AS draft FROM cms_demo WHERE is_deleted = FALSE`
    )
    const cats = await db.query(
      `SELECT category, COUNT(*) AS cnt FROM cms_script WHERE status = 'published' AND is_deleted = FALSE GROUP BY category ORDER BY cnt DESC`
    )
    return res.json(success({
      scripts: s[0],
      demos: d[0],
      scriptCats: cats
    }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('统计失败：' + e.message, 500))
  }
}

module.exports = {
  categories,
  scriptList, scriptDetail, scriptAdd, scriptUpdate, scriptToggleStatus, scriptDelete,
  demoList, demoDetail, demoAdd, demoUpdate, demoToggleStatus, demoDelete,
  stats
}
