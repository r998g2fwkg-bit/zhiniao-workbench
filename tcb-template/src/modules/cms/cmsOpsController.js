/**
 * 内容运营控制器（阶段11）
 * 批量操作 / 版本历史 / 操作审计 / 数据看板统计
 * 统一挂载 /api/cms 下：batch、versions、restore、logs、stats
 */

const db = require('../../utils/db')
const { success, error } = require('../../utils/response')

/* ============ 版本与日志 helpers（供 cmsController 复用） ============ */

/** 保存一个内容版本快照（覆盖式：同秒多次更新只留最新） */
async function saveVersion(contentType, contentId, snapshotObj, operatorId) {
  try {
    await db.query(
      `INSERT INTO cms_content_version (content_type, content_id, snapshot, operator_id) VALUES ($1, $2, $3, $4)`,
      [contentType, contentId, JSON.stringify(snapshotObj), operatorId || null]
    )
    /* 仅保留最近 5 个版本 */
    await db.query(
      `DELETE FROM cms_content_version WHERE content_type = $1 AND content_id = $2 AND id NOT IN
       (SELECT id FROM cms_content_version WHERE content_type = $1 AND content_id = $2 ORDER BY id DESC LIMIT 5)`,
      [contentType, contentId]
    )
  } catch (e) { /* 版本保存失败不影响主流程 */ }
}

/** 记录操作日志 */
async function addLog(operatorId, operatorName, opType, targetType, targetId, summary) {
  try {
    await db.query(
      `INSERT INTO cms_op_log (operator_id, operator_name, op_type, target_type, target_id, summary) VALUES ($1, $2, $3, $4, $5, $6)`,
      [operatorId || null, String(operatorName || ''), String(opType || ''), String(targetType || ''), targetId || 0, String(summary || '')]
    )
  } catch (e) { /* 日志失败不影响主流程 */ }
}

/** 动态更新行（复用 cmsController 的 updateRow 逻辑） */
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

/* ============ 批量操作 ============ */

function buildBatch(table, targetType, logLabel) {
  return async function (req, res) {
    try {
      const { ids = [], action = '', category = '', sub_category = '' } = req.body || {}
      if (!Array.isArray(ids) || !ids.length) return res.json(error('请先选择要操作的数据'))
      const idArr = ids.map((x) => parseInt(x, 10)).filter((x) => x > 0)
      if (!idArr.length) return res.json(error('选择的数据无效'))
      /* executePGSql 对 IN ($2,$3...) 参数数组支持差：id 为整数，安全内联；其余单值参数化 */
      const idStr = idArr.join(',')
      let tip = ''
      if (action === 'delete') {
        /* P0 修复：批量删除改为软删除 */
        await db.query(`UPDATE ${table} SET is_deleted = TRUE, status = 'draft', update_time = CURRENT_TIMESTAMP WHERE id IN (${idStr}) AND is_deleted = FALSE`)
        tip = '删除'
      } else if (action === 'publish' || action === 'unpublish') {
        const st = action === 'publish' ? 'published' : 'draft'
        // 批量上架时，将 on_shelf_time 更新为当前时间（仅当目标状态为 published）
        const onShelfSet = action === 'publish' ? ', on_shelf_time = CURRENT_TIMESTAMP' : ''
        /* P0 修复：批量操作不触达已删除记录 */
        await db.query(`UPDATE ${table} SET status = $1, update_time = CURRENT_TIMESTAMP${onShelfSet} WHERE id IN (${idStr}) AND is_deleted = FALSE`, [st])
        tip = action === 'publish' ? '上架' : '下架'
      } else if (action === 'category') {
        if (!category && !sub_category) return res.json(error('请选择目标分类'))
        const sets = ['category = $1', 'update_time = CURRENT_TIMESTAMP']
        const cparams = [String(category)]
        if (sub_category) {
          cparams.push(String(sub_category))
          sets.splice(1, 0, `sub_category = $${cparams.length}`)
        }
        await db.query(`UPDATE ${table} SET ${sets.join(', ')} WHERE id IN (${idStr})`, cparams)
        tip = '修改分类'
      } else {
        return res.json(error('不支持的操作类型'))
      }
      await addLog(req.user.id, req.user.username, 'batch_' + action, targetType, 0, `${logLabel} 批量${tip} ${idArr.length} 条${action === 'category' ? ' → ' + (category || '') + (sub_category ? ' / ' + sub_category : '') : ''}`)
      return res.json(success(null, `已批量${tip} ${idArr.length} 条`))
    } catch (e) {
      return res.status(500).json(error('批量操作失败：' + e.message, 500))
    }
  }
}

const batchScript = buildBatch('cms_script', 'script', '话术')
const batchDemo = buildBatch('cms_demo', 'demo', '演示')
const batchAep = buildBatch('cms_aep_task', 'aep', 'AEP周任务')

/* ============ 版本历史 ============ */

function buildVersions(contentType) {
  return async function (req, res) {
    try {
      const id = parseInt(req.params.id, 10)
      if (!id) return res.json(error('参数错误'))
      const rows = await db.query(
        `SELECT id, snapshot, operator_id, create_time FROM cms_content_version
         WHERE content_type = $1 AND content_id = $2 ORDER BY id DESC LIMIT 5`,
        [contentType, id]
      )
      return res.json(success(rows.map((r) => {
        let snap = {}
        try { snap = JSON.parse(r.snapshot || '{}') } catch (e) {}
        return { id: r.id, snapshot: snap, create_time: r.create_time }
      }), '查询成功'))
    } catch (e) {
      return res.status(500).json(error('查询失败：' + e.message, 500))
    }
  }
}

function buildRestore(contentType, table) {
  return async function (req, res) {
    try {
      const id = parseInt(req.params.id, 10)
      const versionId = parseInt((req.body || {}).version_id, 10)
      if (!id || !versionId) return res.json(error('参数错误'))
      const rows = await db.query(
        `SELECT snapshot FROM cms_content_version WHERE id = $1 AND content_type = $2 AND content_id = $3`,
        [versionId, contentType, id]
      )
      if (!rows.length) return res.json(error('版本不存在'))
      let snap = {}
      try { snap = JSON.parse(rows[0].snapshot || '{}') } catch (e) { return res.json(error('版本数据损坏')) }
      /* 回退前把当前内容留一个版本（不覆盖历史轨迹） */
      const cur = await db.findOne(table, { id }, '*')
      if (cur) await saveVersion(contentType, id, pickSnapshot(contentType, cur), req.user.id)
      const data = {}
      if (snap.title !== undefined) data.title = snap.title
      if (snap.category !== undefined) data.category = snap.category
      if (snap.sub_category !== undefined) data.sub_category = snap.sub_category
      if (snap.content !== undefined) data.content = snap.content
      if (snap.rounds !== undefined) data.rounds = JSON.stringify(snap.rounds)
      if (snap.tags !== undefined) data.tags = snap.tags
      if (snap.status !== undefined) data.status = snap.status
      if (snap.description !== undefined) data.description = snap.description
      if (!Object.keys(data).length) return res.json(error('版本无可用内容'))
      await updateRow(table, data, id)
      await addLog(req.user.id, req.user.username, 'restore', contentType, id, `回退到版本 #${versionId}`)
      return res.json(success(null, '已回退'))
    } catch (e) {
      return res.status(500).json(error('回退失败：' + e.message, 500))
    }
  }
}

/** 从表行提取版本快照（script / demo） */
function pickSnapshot(contentType, row) {
  if (contentType === 'demo') {
    return { title: row.title, category: row.category, description: row.description, content: row.content, status: row.status }
  }
  let rounds = null
  try { rounds = JSON.parse(row.rounds || 'null') } catch (e) {}
  return { title: row.title, category: row.category, sub_category: row.sub_category, rounds, tags: row.tags, content: row.content, status: row.status }
}

const scriptVersions = buildVersions('script')
const demoVersions = buildVersions('demo')
const scriptRestore = buildRestore('script', 'cms_script')
const demoRestore = buildRestore('demo', 'cms_demo')

/* ============ 操作审计日志 ============ */

async function logList(req, res) {
  try {
    const { operator = '', op_type = '', target_type = '', start = '', end = '', page = 1, pageSize = 20 } = req.query
    const cond = []
    const params = []
    let i = 1
    if (operator) { cond.push(`operator_name ILIKE $${i}`); params.push('%' + operator + '%'); i++ }
    if (op_type) { cond.push(`op_type = $${i}`); params.push(op_type); i++ }
    if (target_type) { cond.push(`target_type = $${i}`); params.push(target_type); i++ }
    if (start) { cond.push(`create_time >= $${i}::timestamp`); params.push(start); i++ }
    if (end) { cond.push(`create_time <= $${i}::timestamp`); params.push(end); i++ }
    const where = cond.length ? ' WHERE ' + cond.join(' AND ') : ''
    const count = await db.query(`SELECT COUNT(*) AS total FROM cms_op_log${where}`, params)
    const total = parseInt(count[0].total, 10) || 0
    const limit = parseInt(pageSize, 10) || 20
    const offset = (parseInt(page, 10) - 1) * limit
    const rows = await db.query(
      `SELECT id, operator_name, op_type, target_type, target_id, summary, create_time FROM cms_op_log${where}
       ORDER BY id DESC LIMIT $${i} OFFSET $${i + 1}`,
      params.concat([limit, offset])
    )
    return res.json(success({ list: rows, total, page: parseInt(page, 10), pageSize: limit }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/* ============ 数据看板统计 ============ */

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
    const aepActive = await db.query(
      `SELECT COUNT(*) AS cnt FROM cms_aep_task WHERE status = 'published' AND expire_time >= CURRENT_DATE`
    )
    const aepTrend = await db.query(
      `SELECT week_start, COUNT(*) AS cnt FROM cms_aep_task WHERE status = 'published' AND week_start >= CURRENT_DATE - INTERVAL '28 days' GROUP BY week_start ORDER BY week_start`
    )
    return res.json(success({
      scripts: s[0],
      demos: d[0],
      scriptCats: cats,
      aepActive: parseInt(aepActive[0].cnt, 10) || 0,
      aepTrend
    }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('统计失败：' + e.message, 500))
  }
}

module.exports = {
  saveVersion, addLog, pickSnapshot,
  batchScript, batchDemo, batchAep,
  scriptVersions, demoVersions, scriptRestore, demoRestore,
  logList, stats
}
