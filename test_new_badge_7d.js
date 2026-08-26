// 知鸟答案工作台 · 三端「新上架」清单一致性核验（替代旧的 7 天口径测试）
const fs = require('fs');
const path = require('path');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const files = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html'];

const FEATURE_TOKENS = [
  'const NEWLY_ADDED = window.__APP_DATA__.NEWLY_ADDED||[];',
  'let newOnly=false;',
  'id="statNew"',
  'function toggleNewOnly',
  'function newBadge',
  'function bindStatClicks',
  'if(newOnly) list=list.filter(x=>NEWLY_ADDED.includes(x.id)&&x.status!==\'archived\');'
];

for (const f of files) {
  const html = fs.readFileSync(path.join(root, f), 'utf-8');

  // 旧的 7 天口径必须已移除
  if (html.includes('新增（7天）') || html.includes('cutoff.setDate(cutoff.getDate()-7)') || html.includes('7天内新增的主题')) {
    throw new Error(`${f}: stale 7-day label/cutoff still present`);
  }

  // 新功能关键 token 必须齐全
  for (const token of FEATURE_TOKENS) {
    if (!html.includes(token)) {
      throw new Error(`${f}: missing feature token -> ${token}`);
    }
  }

  // NEWLY_ADDED 数据键存在于注入 blob
  if (!html.includes('"NEWLY_ADDED"')) {
    throw new Error(`${f}: data blob missing NEWLY_ADDED key`);
  }

  console.log(`${f}: 7-day removed, NEWLY_ADDED feature tokens OK`);
}

console.log('All checks passed.');
