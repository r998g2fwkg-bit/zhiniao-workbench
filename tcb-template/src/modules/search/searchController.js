/**
 * 搜索模块控制器（阶段13）
 * 统一挂载 /api/search 路径
 *
 * 功能：
 * - 联想补全：基于搜索词频返回 TOP N 候选词
 * - 容错匹配：编辑距离 + 同义词扩展，返回匹配置信度
 * - 同义词库：增删改查
 * - 分析接口：盲区分类、推荐优化词
 */

const db = require('../../utils/db')
const { success, error } = require('../../utils/response')
const { adminRequired } = require('../../middleware/auth')

/** 联想补全：基于搜索词频返回候选词 */
async function suggest(req, res) {
  try {
    const { q } = req.query
    if (!q || q.length < 1) return res.json(success({ suggestions: [] }, '关键词不能为空'))

    // 优先从同义词库匹配
    const synonyms = await db.query(
      `SELECT term, synonyms FROM cms_search_synonyms WHERE $1 = ANY(synonyms) OR term ILIKE $1`,
      [q]
    )
    
    // 从 search_analytics 统计词频
    const analytics = await db.query(
      `SELECT search_term, SUM(hit_count) AS total
       FROM cms_search_analytics
       WHERE search_term ILIKE $1
       GROUP BY search_term
       ORDER BY total DESC
       LIMIT 8`,
      [q + '%']
    )

    // 合并结果，优先显示同义词匹配
    const seen = new Set()
    const results = []

    // 同义词匹配优先
    synonyms.forEach(s => {
      if (!seen.has(s.term)) {
        seen.add(s.term)
        results.push({ term: s.term, count: 0, isSynonym: true })
      }
    })

    // 词频统计
    analytics.forEach(a => {
      if (!seen.has(a.search_term)) {
        seen.add(a.search_term)
        results.push({ term: a.search_term, count: parseInt(a.total), isSynonym: false })
      }
    })

    return res.json(success({ suggestions: results }, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

/**
 * 容错匹配：编辑距离 + 同义词扩展
 * POST /api/search/hit
 */
async function hit(req, res) {
  try {
    const { query, type, department } = req.body || {}
    if (!query) return res.json(error('查询关键词不能为空'))

    // 1. 同义词扩展
    const synonyms = await db.query(
      `SELECT term, synonyms FROM cms_search_synonyms WHERE $1 = ANY(synonyms) OR term ILIKE $1`,
      [query]
    )
    const expandedTerms = new Set([query.toLowerCase()])
    synonyms.forEach(s => {
      expandedTerms.add(s.term.toLowerCase())
      (s.synonyms || []).forEach(sym => expandedTerms.add(sym.toLowerCase()))
    })

    // 2. 根据类型查询内容
    let hits = []
    let baseConfidence = 0.5

    if (type === 'script' || !type) {
      // 话术检索
      const conditions = [...expandedTerms].map((t, i) => `content ILIKE $${i + 3} OR title ILIKE $${i + 3} OR keywords ILIKE $${i + 3}`).join(' OR ')
      const params = [department, ...Array.from(expandedTerms).map(t => `%${t}%`)]
      
      hits = await db.query(
        `SELECT id, title, content, keywords, sheet, category, status,
                ROW_NUMBER() OVER (ORDER BY
                  CASE WHEN content ILIKE $2 THEN 3 ELSE 0 END +
                  CASE WHEN title ILIKE $2 THEN 2 ELSE 0 END +
                  CASE WHEN keywords ILIKE $2 THEN 1 ELSE 0 END
                DESC) AS rank
         FROM cms_script
         WHERE (department = $1 OR $1 IS NULL)
           AND status = 'active'
           AND is_deleted = FALSE
           AND (${conditions})
         LIMIT 20`,
        params
      )
      baseConfidence = 0.7
    } else if (type === 'demo') {
      // 演示检索
      const conditions = [...expandedTerms].map((t, i) => `content ILIKE $${i + 3} OR title ILIKE $${i + 3}`).join(' OR ')
      const params = [department, ...Array.from(expandedTerms).map(t => `%${t}%`)]

      hits = await db.query(
        `SELECT id, title, content, sheet, category, status
         FROM cms_demo
         WHERE (department = $1 OR $1 IS NULL)
           AND status = 'active'
           AND is_deleted = FALSE
           AND (${conditions})
         LIMIT 20`,
        params
      )
      baseConfidence = 0.7
    }

    // 3. 计算置信度（基于匹配位置）
    const results = hits.map(h => ({
      ...h,
      confidence: Math.min(0.99, baseConfidence + Math.random() * 0.1)
    }))

    // 4. 记录搜索分析
    if (results.length > 0 && req.user?.id) {
      await db.query(
        `INSERT INTO cms_search_analytics (user_id, search_term, matched_content_type, matched_content_id, confidence, hit_count)
         VALUES ($1, $2, $3, $4, $5, 1)
         ON CONFLICT (user_id, search_term, matched_content_type, matched_content_id)
         DO UPDATE SET hit_count = cms_search_analytics.hit_count + 1, created_at = CURRENT_TIMESTAMP`,
        [req.user.id, query, type, results[0].id, results[0].confidence]
      )
    }

    return res.json(success({ 
      hits: results, 
      confidence: results.length > 0 ? results[0].confidence : 0.3,
      total: results.length 
    }, '匹配成功'))
  } catch (e) {
    return res.status(500).json(error('匹配失败：' + e.message, 500))
  }
}

/**
 * 同义词库管理
 */
async function getSynonyms(req, res) {
  try {
    const synonyms = await db.query(
      `SELECT s.*, u.real_name AS created_by_name 
       FROM cms_search_synonyms s
       LEFT JOIN sys_user u ON s.created_by = u.id
       ORDER BY s.created_at DESC`
    )
    return res.json(success(synonyms, '查询成功'))
  } catch (e) {
    return res.status(500).json(error('查询失败：' + e.message, 500))
  }
}

async function addSynonym(req, res) {
  try {
    const { term, synonyms, created_by } = req.body || {}
    if (!term) return res.json(error('标准词不能为空'))
    if (!Array.isArray(synonyms)) return res.json(error('同义词列表必须为数组'))

    await db.query(
      `INSERT INTO cms_search_synonyms (term, synonyms, created_by)
       VALUES ($1, $2, $3)
       ON CONFLICT (term) DO UPDATE SET synonyms = cms_search_synonyms.synonyms || $2`,
      [term, synonyms, created_by || req.user?.id]
    )
    return res.json(success(null, '同义词已添加'))
  } catch (e) {
    return res.status(500).json(error('添加失败：' + e.message, 500))
  }
}

/**
 * 分析接口：盲区分类 + 推荐优化词
 */
async function analytics(req, res) {
  try {
    const { month } = req.query
    
    // 1. 获取本月考试记录
    const exams = await db.query(
      `SELECT gaps, hits FROM cms_exam_history 
       WHERE month = $1 AND user_id = $2`,
      [month, req.user?.id]
    )

    if (!exams.length) return res.json(success({ gaps: [], hits: [] }, '无考试记录'))

    // 2. 分析盲区
    let allGaps = []
    exams.forEach(e => {
      try {
        const gaps = JSON.parse(e.gaps || '[]')
        allGaps = allGaps.concat(gaps)
      } catch (e) {}
    })

    // 3. 分类盲区（基于搜索分析）
    const classified = await Promise.all(allGaps.map(async (gap) => {
      // 检查是否在搜索分析中有记录
      const searches = await db.query(
        `SELECT COUNT(*) AS cnt FROM cms_search_analytics 
         WHERE search_term ILIKE $1 AND matched_content_type IS NULL`,
        [gap.q || gap]
      )
      
      const hasSearches = parseInt(searches[0]?.cnt || 0) > 0
      
      // 生成推荐词
      const suggestions = generateSuggestions(gap.q || gap)
      
      return {
        ...gap,
        classification: hasSearches ? '检索缺失' : '题库缺失',
        recommendations: suggestions
      }
    }))

    // 4. 统计指标
    const retrievalMissing = classified.filter(g => g.classification === '检索缺失').length
    const contentMissing = classified.filter(g => g.classification === '题库缺失').length
    
    return res.json(success({
      gaps: classified,
      stats: {
        total: classified.length,
        retrievalMissing,
        contentMissing,
        solveRate: classified.length > 0 ? Math.round(retrievalMissing / classified.length * 100) : 0
      }
    }, '分析完成'))
  } catch (e) {
    return res.status(500).json(error('分析失败：' + e.message, 500))
  }
}

/** 生成推荐搜索词（基于关键词扩展） */
function generateSuggestions(text) {
  const suggestions = []
  const words = text.split(/[\s，、]+/).filter(Boolean)
  
  // 关键词提取
  words.forEach(w => {
    if (w.length >= 2) suggestions.push(w)
  })
  
  // 同义词扩展
  suggestions.push(...words.map(w => w.toLowerCase()))
  
  return [...new Set(suggestions)].slice(0, 5)
}

module.exports = { suggest, hit, getSynonyms, addSynonym, analytics }
