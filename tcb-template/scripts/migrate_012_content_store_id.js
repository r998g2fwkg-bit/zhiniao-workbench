#!/usr/bin/env node
/**
 * 执行数据库迁移：Phase 2.2 - 内容表 store_id 字段
 * 用法: cd tcb-template && node scripts/migrate_012_content_store_id.js
 *
 * 迁移内容：
 * - 新增 cms_script.store_id BIGINT 字段
 * - 新增 cms_demo.store_id BIGINT 字段
 * - 现有数据保持 NULL（全局可见）
 */

const path = require('path')
const fs = require('fs')

// 手动加载 .env
const envPath = path.join(__dirname, '../.env')
if (fs.existsSync(envPath)) {
  const envContent = fs.readFileSync(envPath, 'utf-8')
  envContent.split('\n').forEach(line => {
    line = line.trim()
    if (line && !line.startsWith('#')) {
      const idx = line.indexOf('=')
      if (idx > 0) {
        const key = line.substring(0, idx).trim()
        const val = line.substring(idx + 1).trim().replace(/^['"]|['"]$/g, '')
        if (!process.env[key]) process.env[key] = val
      }
    }
  })
}

const db = require('../src/utils/db')

async function runMigration() {
  console.log('[migrate_012_content] 开始执行内容表 store_id 迁移...\n')

  try {
    // Step 1: 执行 DDL
    console.log('[migrate_012_content] Step 1: 新增 store_id 字段...')
    await db.query('ALTER TABLE cms_script ADD COLUMN IF NOT EXISTS store_id BIGINT')
    await db.query('CREATE INDEX IF NOT EXISTS idx_cms_script_store_id ON cms_script(store_id) WHERE store_id IS NOT NULL')
    await db.query('ALTER TABLE cms_demo ADD COLUMN IF NOT EXISTS store_id BIGINT')
    await db.query('CREATE INDEX IF NOT EXISTS idx_cms_demo_store_id ON cms_demo(store_id) WHERE store_id IS NOT NULL')
    console.log('[migrate_012_content] ✅ DDL 完成\n')

    // Step 2: 验证字段
    console.log('[migrate_012_content] Step 2: 验证字段...')
    const scriptCols = await db.query(`
      SELECT column_name FROM information_schema.columns
      WHERE table_name = 'cms_script' AND column_name IN ('id', 'store_id', 'department')
      ORDER BY column_name
    `)
    const demoCols = await db.query(`
      SELECT column_name FROM information_schema.columns
      WHERE table_name = 'cms_demo' AND column_name IN ('id', 'store_id', 'department')
      ORDER BY column_name
    `)
    console.log('  cms_script 列:', scriptCols.map(r => r.column_name).join(', '))
    console.log('  cms_demo 列:', demoCols.map(r => r.column_name).join(', '))

    // Step 3: 统计
    console.log('\n[migrate_012_content] Step 3: 统计数据...')
    const scriptCount = await db.query('SELECT COUNT(*) AS c FROM cms_script')
    const demoCount = await db.query('SELECT COUNT(*) AS c FROM cms_demo')
    const scriptWithStoreId = await db.query('SELECT COUNT(*) AS c FROM cms_script WHERE store_id IS NOT NULL')
    const demoWithStoreId = await db.query('SELECT COUNT(*) AS c FROM cms_demo WHERE store_id IS NOT NULL')

    console.log(`  cms_script: ${(scriptCount[0] || {}).c || 0} 条，store_id 非空: ${(scriptWithStoreId[0] || {}).c || 0} 条`)
    console.log(`  cms_demo: ${(demoCount[0] || {}).c || 0} 条，store_id 非空: ${(demoWithStoreId[0] || {}).c || 0} 条`)

    console.log('\n[migrate_012_content] ✅ 迁移完成')
    console.log('注：现有内容数据 store_id 保持 NULL（全局可见），后续可按需迁移')
  } catch (e) {
    console.error('[migrate_012_content] ❌ 迁移失败:', e.message)
    process.exit(1)
  }
}

runMigration()
