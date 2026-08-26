// 知鸟答案工作台 · 「新上架」清单功能测试（jsdom）
const fs = require('fs');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');
const path = require('path');

const ROOT = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const SRC = fs.readFileSync(path.join(ROOT, '知鸟答案工作台.html'), 'utf-8');

let pass = 0, fail = 0;
const failed = [];
function ok(name, cond, extra) {
  if (cond) { pass++; console.log('  ✅ ' + name + (extra ? '  ' + extra : '')); }
  else { fail++; failed.push(name); console.log('  ❌ ' + name + (extra ? '  ' + extra : '')); }
}
function section(title){ console.log('\n=== ' + title + ' ==='); }

const dom = new JSDOM(SRC, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
const w = dom.window, d = w.document, ls = w.localStorage;

// 环境打桩
w.speechSynthesis = { getVoices: () => [], cancel(){}, speak(){}, pause(){}, resume(){}, onvoiceschanged:null };
w.SpeechSynthesisUtterance = function(){};
w.location.reload = () => {};
w.confirm = () => true;
w.alert = () => {};

const ADMIN = 'maximov0607@outlook.com';
function loginAs(email){ ls.setItem('wb_zhiniao_session', email); w.authGate(); w.loadStorage(); w.render(); }
loginAs(ADMIN);

// 顶层 const/let 不在 window 上，用 eval 读取/修改内部状态
function state(){ return w.eval('({ newOnly, onlyFav, recentOnly, onlyArchived, activeSheet, activeCat, NEWLY_ADDED })'); }
function getData(){ return w.eval('data'); }
function setNewOnly(v){ w.eval('newOnly=' + (v?'true':'false')); }

section('数据层：NEWLY_ADDED 注入');
const s = state();
ok(Array.isArray(s.NEWLY_ADDED) && s.NEWLY_ADDED.length >= 1, 'NEWLY_ADDED 非空数组', 'len=' + (s.NEWLY_ADDED||[]).length);
ok(w.__APP_DATA__ && Array.isArray(w.__APP_DATA__.NEWLY_ADDED), '__APP_DATA__.NEWLY_ADDED 存在');
(s.NEWLY_ADDED||[]).forEach(id => {
  const hit = getData().filter(x => x.id === id);
  ok(hit.length > 0, `NEWLY_ADDED 中 ${id} 存在于数据`, hit.length ? `(${hit[0].sheet}/${hit[0].topic})` : '缺失');
});

section('newOnly 状态与 toggleNewOnly');
ok(typeof w.toggleNewOnly === 'function', 'toggleNewOnly 函数存在');
w.toggleNewOnly();
let st = state();
ok(st.newOnly === true, 'toggleNewOnly 开启 newOnly');
ok(st.onlyFav === false && st.recentOnly === false && st.onlyArchived === false, '开启 newOnly 时清除其他筛选');
ok(st.activeSheet === '全部' && st.activeCat === '全部', '开启 newOnly 时重置分区/分类');

section('统计卡「新上架」可点击 + 数量');
try { w.renderStats(); } catch(e){ console.log('  ⚠️ renderStats 异常', e.message); }
const statNew = d.getElementById('statNew');
ok(!!statNew, '统计卡存在 id=statNew');
if (statNew) {
  ok(statNew.className.includes('clickable'), '统计卡带 clickable class');
  const num = parseInt(statNew.querySelector('.num').textContent, 10);
  const DATA = getData();
  const expected = new Set(DATA.filter(x=>s.NEWLY_ADDED.includes(x.id) && !x.isFollowUp && x.status!=='archived').map(x=>x.sheet+'||'+x.topic));
  ok(num === expected.size, '统计卡显示真实新上架数量', `num=${num}, expected=${expected.size}`);
}

section('卡片「新」角标逻辑');
ok(typeof w.newBadge === 'function', 'newBadge 函数存在');
ok((w.newBadge(s.NEWLY_ADDED[0])||'').includes('tag new'), 'newBadge 命中清单返回「新」标');
ok(w.newBadge('__NONEXIST__') === '', 'newBadge 非清单返回空');

section('筛选：新上架过滤生效');
setNewOnly(true);
const groups = w.getVisibleTopicGroups();
const DATA = getData();
const expectedTopics = [...new Set(DATA.filter(x=>s.NEWLY_ADDED.includes(x.id) && !x.isFollowUp && x.status!=='archived').map(x=>x.sheet+'||'+x.topic))];
ok(groups.length === expectedTopics.length, 'getVisibleTopicGroups 仅返回新上架主题', `got=${groups.length}, expected=${expectedTopics.length}`);
groups.forEach(g => ok(s.NEWLY_ADDED.includes(g.items[0].id), `分组首轮「${g.topic}」命中新上架`));

section('复位：setSection / resetAll 重置 newOnly');
setNewOnly(true); w.setSection('script');
ok(state().newOnly === false, 'setSection 重置 newOnly');
setNewOnly(true); w.resetAll();
ok(state().newOnly === false, 'resetAll 重置 newOnly');

section('演示：demo 过滤 + 角标');
w.setSection('demo'); setNewOnly(true);
const dg = w.getVisibleDemoGroups();
ok(Array.isArray(dg), 'getVisibleDemoGroups 可调用');
ok(dg.length === 0, 'demo newOnly 无匹配（NEWLY_ADDED 均为话术ID）', 'dg.length=' + (dg?dg.length:'N/A'));
w.setSection('script'); setNewOnly(false);

console.log('\n=== 结果 ===');
if (fail === 0) { console.log('✅ 全部通过 (' + pass + ' 项)'); }
else { console.log(`❌ ${fail} 项失败:`); failed.forEach(n=>console.log('   - ' + n)); }
process.exit(fail === 0 ? 0 : 1);
