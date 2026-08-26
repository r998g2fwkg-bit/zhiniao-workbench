const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const src = fs.readFileSync(path.join(root, '知鸟答案工作台.html'), 'utf-8');
const dom = new JSDOM(src, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
const w = dom.window, ls = w.localStorage;

function assert(c, m){ if(!c) throw new Error('FAIL: '+m); console.log('OK '+m); }

// 覆盖率看板是管理员专属面板：先以管理员身份登录
ls.setItem('wb_zhiniao_session', 'maximov0607@outlook.com');
w.authGate();

// 空数据：显示空态
ls.setItem('wb_zhiniao_exam_hits', JSON.stringify([]));
ls.setItem('wb_zhiniao_exam_gaps', JSON.stringify([]));
w.renderExamCoverage();
let box = w.document.getElementById('examCoverage');
assert(/覆盖率看板/.test(box.innerHTML), '空数据也渲染看板标题');
assert(/本机暂无月考记录/.test(box.innerHTML), '空数据显示空态提示');

// 构造数据：2 月命中率 + 盲区频次
const hits = [
  {q:'如何激活 iPhone', sheet:'iPhone销售话术系列', topic:'激活 iPhone', itemId:'a1', type:'coach', month:'2026-08'},
  {q:'如何激活 iPhone', sheet:'iPhone销售话术系列', topic:'激活 iPhone', itemId:'a1', type:'coach', month:'2026-08'},
  {q:'Mac 续航', sheet:'Mac销售话术系列', topic:'MacBook 续航', itemId:'m1', type:'coach', month:'2026-08'},
  {q:'AirTag 用法', sheet:'配件和服务销售话术系列', topic:'AirTag 使用', itemId:'t1', type:'coach', month:'2026-07'},
];
const gaps = [
  {q:'iPhone 17 电池容量', key:'iphone17电池容量', month:'2026-08'},
  {q:'iphone 17 的电池容量是多少', key:'iphone17电池容量', month:'2026-08'},
  {q:'以旧换新怎么算价', key:'以旧换新怎么算价', month:'2026-07'},
];
ls.setItem('wb_zhiniao_exam_hits', JSON.stringify(hits));
ls.setItem('wb_zhiniao_exam_gaps', JSON.stringify(gaps));
w.renderExamCoverage();
box = w.document.getElementById('examCoverage');

assert(/累计命中率/.test(box.innerHTML), '显示累计命中率');
// 总题数 = 4 hits + 3 gaps = 7；命中率 = round(4/7*100)=57
assert(/57%/.test(box.innerHTML), '累计命中率=57% (4/7)');
assert(/已沉淀 7 题/.test(box.innerHTML), '已沉淀 7 题');
assert(/各月命中率/.test(box.innerHTML), '显示各月命中率区块');
assert(/盲区 Top（待补频次）/.test(box.innerHTML), '显示盲区 Top');
assert(/命中热度 Top/.test(box.innerHTML), '显示命中热度 Top');
// 盲区 Top 中 iphone17电池容量 出现 2 次应排第一，且显示「2 次」
assert(/iphone17电池容量|iPhone 17 电池容量|iphone 17 的电池容量是多少/.test(box.innerHTML), '盲区 Top 含 iPhone 17 电池题');
assert(/2 次/.test(box.innerHTML), '盲区频次显示 2 次');
// 命中热度：激活 iPhone 出现 2 次排第一
assert(/激活 iPhone/.test(box.innerHTML), '命中热度含「激活 iPhone」');

console.log('ALL COVERAGE TESTS PASSED');
