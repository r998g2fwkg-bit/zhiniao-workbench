// 知鸟工作台 · 「课时追踪」版块集成冒烟（jsdom 交互级）
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const ROOT = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const ADMIN = 'maximov0607@outlook.com';
const TEST_COACH = 'rikchou@icloud.com';
const SRC = fs.readFileSync(path.join(ROOT, '知鸟答案工作台.html'), 'utf-8');

let pass = 0, fail = 0;
const failed = [];
function ok(name, cond, extra) {
  if (cond) { pass++; console.log('  OK  ' + name + (extra ? '  ' + extra : '')); }
  else { fail++; failed.push(name); console.log('  XX  ' + name + (extra ? '  ' + extra : '')); }
}
function section(t){ console.log('\n=== ' + t + ' ==='); }

const dom = new JSDOM(SRC, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
const w = dom.window, d = w.document, ls = w.localStorage;
// 环境打桩
w.speechSynthesis = { getVoices: () => [], cancel(){}, speak(){}, pause(){}, resume(){}, onvoiceschanged:null };
w.SpeechSynthesisUtterance = function(){};
w.syncNotices = () => {}; w.showToast = () => {};
w.location.reload = () => {}; w.confirm = () => true;
if (!w.navigator.clipboard) { try { Object.defineProperty(w.navigator, 'clipboard', { value: { writeText: () => Promise.resolve() }, configurable: true }); } catch(e){} }

function loginAs(email){ ls.setItem('wb_zhiniao_session', email); w.authGate(); w.loadStorage(); w.render(); }

section('0. 基础');
ok('关键函数已定义', typeof w.render==='function' && typeof w.setSection==='function' && typeof w.updateHoursEntry==='function' && typeof w.canSeeHours==='function' && typeof w.renderHours==='function');
ok('HOURS_URL 常量存在', typeof w.eval('HOURS_URL')==='string' && w.eval('HOURS_URL').includes('课时追踪.html'), '=' + w.eval('HOURS_URL'));
ok('data-sec=hours 导航按钮存在', !!d.querySelector('#sectionTabs .sec-tab[data-sec="hours"]'));
ok('hoursWrap/hoursFrame 存在', !!d.getElementById('hoursWrap') && !!d.getElementById('hoursFrame'));

section('1. 管理员（正式 Coach）视角');
loginAs(ADMIN);
w.setSection('hours');
const hw = d.getElementById('hoursWrap');
ok('hoursWrap 显示', hw.style.display==='' || hw.style.display==='block');
ok('hoursFrame src 指向 HOURS_URL+store', (d.getElementById('hoursFrame').getAttribute('src')||'').indexOf('课时追踪.html?store=')===0, 'src=' + d.getElementById('hoursFrame').getAttribute('src'));
ok('hours 导航按钮可见', d.querySelector('#sectionTabs .sec-tab[data-sec="hours"]').style.display !== 'none');
ok('cardList 隐藏（hours 专属页）', d.getElementById('cardList').style.display==='none');
ok('切走后 hoursWrap 隐藏', (w.setSection('script'), d.getElementById('hoursWrap').style.display==='none'));
ok('切走时释放 iframe', d.getElementById('hoursFrame').getAttribute('src')==='about:blank');

section('2. 测试账号视角（屏蔽入口）');
loginAs(TEST_COACH);
const btn = d.querySelector('#sectionTabs .sec-tab[data-sec="hours"]');
ok('测试账号: hours 导航按钮 display:none', btn.style.display==='none', 'display=' + btn.style.display);
w.setSection('hours'); // 即使强制切过去也应隐藏内容
ok('测试账号: hoursWrap 仍隐藏', d.getElementById('hoursWrap').style.display==='none');
ok('测试账号: 若被强制进入 hoursFrame 为 about:blank', d.getElementById('hoursFrame').getAttribute('src')==='about:blank');

section('3. 管理员恢复');
loginAs(ADMIN);
w.setSection('hours');
ok('管理员: hours 导航按钮恢复可见', d.querySelector('#sectionTabs .sec-tab[data-sec="hours"]').style.display !== 'none');
ok('管理员: hoursWrap 重新显示', d.getElementById('hoursWrap').style.display==='' || d.getElementById('hoursWrap').style.display==='block');

console.log('\n结果: pass=' + pass + ' fail=' + fail);
if (failed.length) console.log('失败项: ' + failed.join(' | '));
process.exit(fail ? 1 : 0);
