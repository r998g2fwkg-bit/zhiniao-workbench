#!/usr/bin/env node
/**
 * 执行数据库迁移：Phase 2.1 - sys_user 门店 ID 字段
 * 用法: cd tcb-template && node scripts/migrate_012_user_store_id.js
 *
 * 迁移内容：
 * - 新增 sys_user.store_id BIGINT 字段
 * - 根据 department 名称映射填充 store_id
 * - 验证所有用户均可正确映射
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

// 门店名称 → store_id 映射（与 Phase 1 保持一致）
const STORE_NAME_TO_ID = {
  '长沙河西王府井店': 1402134,
  '长沙万象城店': 4281296,
  '长沙国金街店': 2841665,
  '长沙北辰荟店': 3441478,
  '长沙梅溪湖金茂店': 1542844,
  // 别名兼容
  '梅溪湖金茂店': 1542844,
  '方兴金茂店': 1542844,
  '王府井': 1402134,
  '万象城': 4281296,
  '国金街': 2841665,
  '北辰荟': 3441478,
  '梅溪湖': 1542844
}

async function runMigration() {
  console.log('[migrate_012_user] 开始执行 sys_user store_id 迁移...\n')

  try {
    // Step 1: 执行 DDL
    console.log('[migrate_012_user] Step 1: 新增 store_id 字段...')
    await db.query('ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS store_id BIGINT')
    await db.query('CREATE INDEX IF NOT EXISTS idx_sys_user_store_id ON sys_user(store_id) WHERE store_id IS NOT NULL')
    console.log('[migrate_012_user] ✅ DDL 完成\n')

    // Step 2: 查询所有用户
    console.log('[migrate_012_user] Step 2: 迁移用户 store_id...')
    const users = await db.query(`
      SELECT id, username, real_name, department, store_id
      FROM sys_user
      ORDER BY id
    `)

    let mapped = 0
    let skipped = 0
    const unmapped = []

    for (const user of users) {
      const dept = String(user.department || '').trim()
      if (!dept) {
        console.warn(`  ⚠️  用户 ${user.username} 无 department，跳过`)
        skipped++
        continue
      }

      // 查找映射
      let storeId = null
      if (user.store_id) {
        storeId = parseInt(user.store_id, 10)
      } else {
        // 精确匹配
        if (STORE_NAME_TO_ID[dept]) {
          storeId = STORE_NAME_TO_ID[dept]
        } else {
          // 模糊匹配（检查是否包含关键字）
          for (const [name, id] of Object.entries(STORE_NAME_TO_ID)) {
            if (dept.includes(name) || name.includes(dept)) {
              storeId = id
              break
            }
          }
        }
      }

      if (storeId) {
        await db.query(
          'UPDATE sys_user SET store_id = $1, update_time = CURRENT_TIMESTAMP WHERE id = $2',
          [storeId, user.id]
        )
        console.log(`  ✓ ${user.username} (${user.real_name}) → store_id=${storeId} [${dept}]`)
        mapped++
      } else {
        console.warn(`  ✗ ${user.username} 无法映射 department: "${dept}"`)
        unmapped.push({ username: user.username, real_name: user.real_name, department: dept })
        skipped++
      }
    }

    console.log(`\n[migrate_012_user] 迁移结果: ${mapped} 条已映射, ${skipped} 条跳过\n`)

    // Step 3: 验证
    console.log('[migrate_012_user] Step 3: 验证结果...')
    const verifyRows = await db.query(`
      SELECT id, username, real_name, department, store_id
      FROM sys_user
      ORDER BY id
    `)
    console.log('\n[user_list]')
    verifyRows.forEach(r => {
      console.log(`  id=${r.id} store_id=${r.store_id || 'NULL'} dept="${r.department}" name="${r.real_name}"`)
    })

    const totalUsers = verifyRows.length
    const withStoreId = verifyRows.filter(r => r.store_id !== null).length
    const nullCount = totalUsers - withStoreId

    console.log(`\n[stats]`)
    console.log(`  总用户数: ${totalUsers}`)
    console.log(`  store_id 已填充: ${withStoreId}`)
    console.log(`  store_id NULL: ${nullCount}`)

    if (unmapped.length > 0) {
      console.warn('\n[unmapped] 无法映射的用户:')
      unmapped.forEach(u => console.warn(`  - ${u.username} (${u.real_name}): "${u.department}"`))
      throw new Error('存在无法映射 store_id 的用户，请手动处理')
    }

    if (nullCount > 0) {
      throw new Error(`有 ${nullCount} 个用户未映射 store_id`)
    }

    console.log('\n[migrate_012_user] ✅ 迁移完成')
  } catch (e) {
    console.error('[migrate_012_user] ❌ 迁移失败:', e.message)
    process.exit(1)
  }
}

runMigration()
