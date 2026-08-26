// P1④ 验证：置信度 / 标题高亮 / 近似候选（纯函数 + 真实题库集成）
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const files = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html'];

for (const f of files) {
  const html = fs.readFileSync(path.join(root, f), 'utf-8');
  const dom = new JSDOM(html, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
  const w = dom.window;

  // 1) 置信度映射
  const c1 = w.examConfidence(1), c2 = w.examConfidence(0.9), c3 = w.examConfidence(0.75);
  if (c1.label !== '精确匹配' || c1.pct !== 100) throw new Error(`${f}: conf(1) wrong`);
  if (c2.label !== '高度匹配' || c3.label !== '按序匹配') throw new Error(`${f}: conf labels wrong`);

  // 2) 标题命中高亮（包含匹配）
  const hl = w.examHighlightTitleFrag('iphone17', 'iPhone 17 电池容量');
  if (!hl.includes('<mark>') || hl.includes('电池容量</mark>') || !hl.includes('电池容量')) {
    throw new Error(`${f}: highlight wrong -> ${hl}`);
  }

  // 3) 按序匹配高亮（离散字符）
  const hl2 = w.examHighlightTitleFrag('第三方表带', '第三方硅胶表带推荐');
  if (!hl2.includes('<mark>')) throw new Error(`${f}: seq highlight empty -> ${hl2}`);

  // 4) 近似候选（真实题库集成）
  const hit = w.examMatchOne({ order: 0, seq: 1, raw: '诚意满满', text: '诚意满满', hintType: null, hintTag: null }, null, 'coach');
  if (!hit || hit.type === 'unknown') throw new Error(`${f}: matchOne failed for 诚意满满`);
  if (!Array.isArray(hit.candidates)) throw new Error(`${f}: candidates not array`);
  // 诚意满满 应高置信命中，候选可能为空或低分；这里只验证结构
  hit.candidates.forEach(c => {
    if (typeof c.score !== 'number' || !c.topic || !c.id) throw new Error(`${f}: candidate shape wrong`);
  });

  // 5) 近似候选逻辑（合成池，排除最佳后取次优）
  const pool = [
    { key: 'a', topic: 'iPhone 17 电池', sheet: 'S', items: [{ id: 'i1' }] },
    { key: 'b', topic: 'iPhone 17 续航', sheet: 'S2', items: [{ id: 'i2' }] }
  ];
  const cands = w.examCandidateList(pool, 'iphone17电池', 'coach', 'a', 2);
  if (cands.length !== 1 || cands[0].topic !== 'iPhone 17 续航') throw new Error(`${f}: candidateList wrong -> ${JSON.stringify(cands)}`);

  // 6) 徽章渲染
  const badge = w.examConfBadge(0.9);
  if (!badge.includes('高度匹配') || !badge.includes('class="exam-conf')) throw new Error(`${f}: badge wrong -> ${badge}`);

  console.log(`${f}: P1④ 全部通过 (matchType=${hit.type}, conf=${Math.round(hit.score*100)}%, cands=${hit.candidates.length})`);
}
console.log('ALL EXAM-ENH TESTS PASSED');
