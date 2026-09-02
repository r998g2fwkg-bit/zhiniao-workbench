-- ============================================================
-- Phase 2.2: 内容表 store_id 字段
-- 在 cms_script 和 cms_demo 新增 store_id BIGINT
-- 保留 department 字段向后兼容
-- ============================================================

-- 1. cms_script 新增 store_id
ALTER TABLE cms_script ADD COLUMN IF NOT EXISTS store_id BIGINT;
CREATE INDEX IF NOT EXISTS idx_cms_script_store_id ON cms_script(store_id) WHERE store_id IS NOT NULL;

-- 2. cms_demo 新增 store_id
ALTER TABLE cms_demo ADD COLUMN IF NOT EXISTS store_id BIGINT;
CREATE INDEX IF NOT EXISTS idx_cms_demo_store_id ON cms_demo(store_id) WHERE store_id IS NOT NULL;
