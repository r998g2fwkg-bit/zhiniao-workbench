-- ============================================================
-- Phase 2.1: 用户表 store_id 字段
-- 在 sys_user 新增 store_id BIGINT，用于替代 department 字符串作为门店身份主键
-- 保留 department 字段向后兼容，新代码优先使用 store_id
-- ============================================================

-- 1. 新增 store_id 字段（允许 NULL，存量数据需迁移填充）
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS store_id BIGINT;

-- 2. 创建索引加速查询
CREATE INDEX IF NOT EXISTS idx_sys_user_store_id ON sys_user(store_id) WHERE store_id IS NOT NULL;
