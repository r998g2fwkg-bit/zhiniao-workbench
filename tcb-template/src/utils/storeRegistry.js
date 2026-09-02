/**
 * Store Registry 兼容性映射层
 * 提供 store_id ↔ 门店名称的双向映射，支持新旧系统平滑过渡
 *
 * 设计原则：
 * 1. 新代码优先使用 store_id，禁止将门店名称作为唯一主键
 * 2. 旧代码仍可读取 department 字段，不影响现有功能
 * 3. 无法映射的数据单独列出，不猜测归属
 */

// 门店 ID → 名称映射（权威来源）
const STORE_ID_TO_NAME = {
  1402134: '长沙河西王府井店',
  4281296: '长沙万象城店',
  2841665: '长沙国金街店',
  3441478: '长沙北辰荟店',
  1542844: '长沙梅溪湖金茂店'
}

// 门店名称 → ID 映射（含别名）
const STORE_NAME_TO_ID = {
  // 标准名称
  '长沙河西王府井店': 1402134,
  '长沙万象城店': 4281296,
  '长沙国金街店': 2841665,
  '长沙北辰荟店': 3441478,
  '长沙梅溪湖金茂店': 1542844,
  // 常见别名
  '王府井': 1402134,
  '万象城': 4281296,
  '国金街': 2841665,
  '北辰荟': 3441478,
  '梅溪湖': 1542844,
  '梅溪湖金茂店': 1542844,
  '方兴金茂店': 1542844
}

/**
 * 根据门店名称查找 store_id
 * @param {string} name - 门店名称
 * @returns {number|null} store_id 或 null（无法映射）
 */
function resolveStoreId(name) {
  if (!name) return null
  const trimmed = String(name).trim()
  // 精确匹配
  if (STORE_NAME_TO_ID[trimmed]) {
    return STORE_NAME_TO_ID[trimmed]
  }
  // 模糊匹配（包含关系）
  for (const [key, id] of Object.entries(STORE_NAME_TO_ID)) {
    if (trimmed.includes(key) || key.includes(trimmed)) {
      return id
    }
  }
  return null
}

/**
 * 根据 store_id 查找门店名称
 * @param {number} storeId - store_id
 * @returns {string|null} 门店名称或 null
 */
function resolveStoreName(storeId) {
  if (!storeId) return null
  const id = parseInt(storeId, 10)
  return STORE_ID_TO_NAME[id] || null
}

/**
 * 验证 store_id 是否有效
 * @param {number} storeId
 * @returns {boolean}
 */
function isValidStoreId(storeId) {
  return storeId !== null && storeId !== undefined && STORE_ID_TO_NAME[parseInt(storeId, 10)] !== undefined
}

/**
 * 获取所有门店列表（含 store_id 和名称）
 * @returns {Array<{id: number, name: string, store_id: number}>}
 */
function getAllStores() {
  return Object.entries(STORE_ID_TO_NAME).map(([id, name]) => ({
    id: parseInt(id, 10),
    name,
    store_id: parseInt(id, 10)
  }))
}

/**
 * 批量解析 store_id（用于迁移脚本）
 * @param {Array<{name: string}>} items
 * @returns {{mapped: Array, unmapped: Array}}
 */
function batchResolve(items) {
  const mapped = []
  const unmapped = []
  for (const item of items) {
    const id = resolveStoreId(item.name)
    if (id) {
      mapped.push({ ...item, store_id: id })
    } else {
      unmapped.push(item)
    }
  }
  return { mapped, unmapped }
}

module.exports = {
  STORE_ID_TO_NAME,
  STORE_NAME_TO_ID,
  resolveStoreId,
  resolveStoreName,
  isValidStoreId,
  getAllStores,
  batchResolve
}
