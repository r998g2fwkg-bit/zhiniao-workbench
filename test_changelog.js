// P0② 验证（现行架构）：最近更新已合并入消息中心，由 renderChangelogInPanel 渲染
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const files = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html'];

for (const f of files) {
  const html = fs.readFileSync(path.join(root, f), 'utf-8');
  const dom = new JSDOM(html, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
  const w = dom.window, ls = w.localStorage;
  // 消息中心双标签：切换到「更新日志」
  w.noticePanelTab = 'changelog';
  w.renderNoticePanel();
  const p = w.document.getElementById('noticePanel');
  if (!p) throw new Error(`${f}: #noticePanel 缺失`);
  const items = p.querySelectorAll('.cl-item');
  if (items.length < 1) throw new Error(`${f}: 更新日志未渲染条目`);
  const txt = p.textContent;
  if (!/2026-08/.test(txt)) throw new Error(`${f}: 更新日志缺少日期 -> ${txt}`);
  console.log(`${f}: 更新日志(消息中心) OK (${items.length} 条)`);
}
console.log('ALL CHANGELOG TESTS PASSED');
