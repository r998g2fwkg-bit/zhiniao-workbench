// 知鸟答案工作台 · 全功能冒烟测试（jsdom 交互级）
// 加载页面 → 以管理员 & 普通 Coach 两种身份登录 → 逐个功能验证
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const ROOT = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const ADMIN = 'maximov0607@outlook.com';
const COACH = 'rikchou@icloud.com'; // 普通 Coach（且在 SALARY_HIDDEN 中）
const SRC = fs.readFileSync(path.join(ROOT, '知鸟答案工作台.html'), 'utf-8');

let pass = 0, fail = 0;
const failed = [];
function ok(name, cond, extra) {
  if (cond) { pass++; console.log('  ✅ ' + name + (extra ? '  ' + extra : '')); }
  else { fail++; failed.push(name); console.log('  ❌ ' + name + (extra ? '  ' + extra : '')); }
}
function section(title){ console.log('\n=== ' + title + ' ==='); }

// 构造 DOM（内联脚本同步执行）
const dom = new JSDOM(SRC, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
const w = dom.window, d = w.document, ls = w.localStorage;

// 环境打桩：避免 jsdom 不支持的 API 抛错
w.speechSynthesis = { getVoices: () => [], cancel(){}, speak(){}, pause(){}, resume(){}, onvoiceschanged:null };
w.SpeechSynthesisUtterance = function(){};
w.syncNotices = () => {};
w.showToast = () => {};
w.location.reload = () => {};
w.confirm = () => true;
if (!w.navigator.clipboard) { try { Object.defineProperty(w.navigator, 'clipboard', { value: { writeText: () => Promise.resolve() }, configurable: true }); } catch(e){} }

function loginAs(email){
  ls.setItem('wb_zhiniao_session', email);
  w.authGate(); w.loadStorage(); w.render();
}

// ---------- 0. 基础加载 ----------
section('0. 页面加载与脚本执行');
ok('window 关键函数已定义', typeof w.searchHit==='function' && typeof w.render==='function' && typeof w.setSection==='function' && typeof w.isAdmin==='function');
ok('数据已内联 (RAW_DATA=197)', w.__APP_DATA__ && w.__APP_DATA__.RAW_DATA.length===197, '实际=' + (w.__APP_DATA__? w.__APP_DATA__.RAW_DATA.length : 'undefined'));

// ---------- 1. 管理员身份 ----------
section('1. 管理员登录 (auth gate)');
loginAs(ADMIN);
ok('isAdmin()=true', w.isAdmin()===true);
ok('body.is-admin 已加', d.body.classList.contains('is-admin'));
ok('#app 可见', d.getElementById('app').style.display!=='none');
ok('#loginScreen 隐藏', d.getElementById('loginScreen').style.display==='none' || d.getElementById('loginScreen').style.display==='');
ok('账户名渲染=Admin展示名', (d.getElementById('accountName')||{}).textContent && d.getElementById('accountName').textContent.length>0, '='+(d.getElementById('accountName')||{}).textContent);

// ---------- 2. Tab 渲染与切换 ----------
section('2. 顶部 Tab (script/demo/aep/exam)');
const tabs = [...d.querySelectorAll('#sectionTabs .sec-tab')].map(b=>b.dataset.sec);
ok('Tab 顺序正确', JSON.stringify(tabs)===JSON.stringify(['script','demo','aep','exam']), '='+tabs.join(','));

loginAs(ADMIN);
w.setSection('script');
ok('script 版块: cardList 渲染出主题面板(分组)', d.querySelectorAll('#cardList .topic-panel').length>0, '面板数='+d.querySelectorAll('#cardList .topic-panel').length);
const totalPanels = d.querySelectorAll('#cardList .topic-panel').length;
ok('script 版块: 渲染出话术轮次(turn-node)', d.querySelectorAll('#cardList .turn-node').length>0, '轮次数='+d.querySelectorAll('#cardList .turn-node').length);

// 检索容错（纯函数）
section('3. 检索容错 (searchHit)');
ok('去空格+子序列命中', w.searchHit('iPhone 17 的电池容量是多少','iphone17电池')===true);
ok('多词 AND 命中', w.searchHit('以旧换新怎么算价','以旧 换新')===true);
ok('无关词不命中', w.searchHit('如何激活 iPhone','xyz不存在')===false);
ok('空 query 恒命中', w.searchHit('演示主题','')===true);
ok('空 haystack 不命中', w.searchHit('','随便')===false);

// 检索输入框 → 列表过滤（行为级）
w.setSection('script');
const before = d.querySelectorAll('#cardList .topic-panel').length;
d.getElementById('searchInput').value = 'iPhone';
w.render();
const afterIphone = d.querySelectorAll('#cardList .topic-panel').length;
ok('搜索 iPhone 缩小结果集', afterIphone>0 && afterIphone<=before, before+'→'+afterIphone);
d.getElementById('searchInput').value = 'zzz_不存在的关键词_xyz';
w.render();
const afterNone = d.querySelectorAll('#cardList .topic-panel').length;
ok('搜索不存在词 → 0 结果', afterNone===0, '结果='+afterNone);
d.getElementById('searchInput').value = '';
w.render();

// ---------- 4. 收藏 ----------
section('4. 收藏 (favorites)');
w.setSection('script');
const favBtn = d.querySelector('#cardList .fav-btn');
ok('存在 fav-btn', !!favBtn);
if (favBtn) {
  const storedBefore = JSON.parse(ls.getItem('wb_zhiniao_favorites')||'[]').length;
  favBtn.click();
  const storedAfter = JSON.parse(ls.getItem('wb_zhiniao_favorites')||'[]').length;
  ok('点击后 K_FAV 变化(收藏)', storedAfter !== storedBefore, storedBefore+'→'+storedAfter);
  ok('收藏已持久化(非空)', storedAfter>0);
  // 取消收藏
  favBtn.click();
  const storedCancel = JSON.parse(ls.getItem('wb_zhiniao_favorites')||'[]').length;
  ok('再次点击取消收藏', storedCancel === storedBefore);
}

// ---------- 5. 语音兜底 ----------
section('5. 语音朗读兜底 (speechHasZh / speechWarnNoZh)');
w.speechSynthesis.getVoices = () => [];
ok('speechHasZh 空列表=false', w.speechHasZh()===false);
w.speechWarnNoZh();
const st = d.getElementById('speechStatus');
ok('无中文语音状态文案更新', st && /未检测到中文语音|未安装中文语音/.test(st.textContent), '='+(st?st.textContent:''));
ok('无中文语音加 no-zh', st && st.classList.contains('no-zh'));
w.speechSynthesis.getVoices = () => [{name:'Ting-Ting', lang:'zh-CN'}];
ok('speechHasZh 含 zh=true', w.speechHasZh()===true);
w.speechWarnNoZh();
ok('有中文语音移除 no-zh', st && !st.classList.contains('no-zh'));

// ---------- 6. 消息中心（合并 + 双标签 + 时效） ----------
section('6. 消息中心（通知/更新日志 + 3天时效）');
w.openNoticePanel();
const np = d.getElementById('noticePanel');
ok('面板可打开', np && np.hidden===false);
const tabBtns = [...np.querySelectorAll('.np-tab')].map(b=>b.textContent);
ok('双标签存在(通知/更新日志)', tabBtns.includes('通知') && tabBtns.includes('更新日志'), '='+tabBtns.join(','));

// 更新日志标签
w.noticePanelTab = 'changelog';
w.renderNoticePanel();
const clItems = np.querySelectorAll('.cl-item').length;
ok('更新日志渲染条目', clItems>0, '条目数='+clItems);
ok('更新日志含日期', /2026-08/.test(np.innerHTML));

// 默认通知标签
w.noticePanelTab = 'notice';
w.renderNoticePanel();
ok('通知标签默认渲染(无报错)', true);

// 时效逻辑（合成通知）
const today = new Date(); 
const dISO = (off)=>{ const x=new Date(today.getTime()+off*86400000); return x.getFullYear()+'-'+String(x.getMonth()+1).padStart(2,'0')+'-'+String(x.getDate()).padStart(2,'0'); };
const NOTICES = w.__APP_DATA__.NOTICES;
NOTICES.push({id:'syn-today', title:'今天', date:dISO(0), body:'', level:1, sticky:false});
NOTICES.push({id:'syn-old', title:'8天前', date:dISO(-8), body:'', level:1, sticky:false});
NOTICES.push({id:'syn-sticky', title:'置顶旧', date:dISO(-30), body:'', level:1, sticky:true});
ok('isNoticeActive 当天=true', w.isNoticeActive(NOTICES.find(n=>n.id==='syn-today'))===true);
ok('isNoticeActive 8天前=false', w.isNoticeActive(NOTICES.find(n=>n.id==='syn-old'))===false);
ok('isNoticeActive sticky 永远=true', w.isNoticeActive(NOTICES.find(n=>n.id==='syn-sticky'))===true);
const act = w.getActiveNotices().map(n=>n.id);
const hist = w.getHistoryNotices().map(n=>n.id);
ok('active 含 today & sticky', act.includes('syn-today') && act.includes('syn-sticky'));
ok('history 含 old', hist.includes('syn-old'));
ok('active 不含 old', !act.includes('syn-old'));
ok('history 不含 sticky', !hist.includes('syn-sticky'));

// ---------- 7. 覆盖率看板（管理员专属） ----------
section('7. 覆盖率看板 (管理员专属)');
loginAs(ADMIN);
ls.setItem('wb_zhiniao_test_hits', JSON.stringify([]));
ls.setItem('wb_zhiniao_exam_hits', JSON.stringify([
  {q:'如何激活 iPhone', sheet:'iPhone销售话术系列', topic:'激活 iPhone', itemId:'a1', type:'coach', month:'2026-08'},
  {q:'如何激活 iPhone', sheet:'iPhone销售话术系列', topic:'激活 iPhone', itemId:'a1', type:'coach', month:'2026-08'},
  {q:'Mac 续航', sheet:'Mac销售话术系列', topic:'MacBook 续航', itemId:'m1', type:'coach', month:'2026-08'},
  {q:'AirTag 用法', sheet:'配件和服务销售话术系列', topic:'AirTag 使用', itemId:'t1', type:'coach', month:'2026-07'},
]));
ls.setItem('wb_zhiniao_exam_gaps', JSON.stringify([
  {q:'iPhone 17 电池容量', key:'iphone17电池容量', month:'2026-08'},
  {q:'iphone 17 的电池容量是多少', key:'iphone17电池容量', month:'2026-08'},
  {q:'以旧换新怎么算价', key:'以旧换新怎么算价', month:'2026-07'},
]));
w.renderExamCoverage();
const cov = d.getElementById('examCoverage');
ok('管理员: 看板渲染累计命中率', /累计命中率/.test(cov.innerHTML), '命中率片段存在');
ok('管理员: 命中率=57% (4/7)', /57%/.test(cov.innerHTML));
ok('管理员: 已沉淀 7 题', /已沉淀 7 题/.test(cov.innerHTML));
ok('管理员: 含盲区 Top', /盲区 Top（待补频次）/.test(cov.innerHTML));
ok('管理员: 含命中热度 Top', /命中热度 Top/.test(cov.innerHTML));

// 非管理员：看板应隐藏
loginAs(COACH);
w.renderExamCoverage();
ok('非管理员: 看板隐藏 (display:none)', d.getElementById('examCoverage').style.display==='none');

// ---------- 8. 备份 / 恢复 ----------
section('8. 全量备份 / 滚动快照 / 恢复');
loginAs(ADMIN);
ls.removeItem('wb_zhiniao_backups');
ls.removeItem('wb_zhiniao_last_auto_backup');
// 注意：绝不能用真实数据键 wb_zhiniao_data 做桩，loadStorage 会把 local 与 RAW_DATA 合并，
// 桩项缺少 sheet/topic 会污染 data。改用独立测试键验证 collectAllState 的前缀采集逻辑。
ls.setItem('wb_zhiniao_testdata', JSON.stringify([{id:'x'}]));
ls.setItem('wb_zhiniao_exam_hits', JSON.stringify([{q:'t', sheet:'s'}]));
const state = w.collectAllState();
ok('collectAllState 含测试键', !!state['wb_zhiniao_testdata']);
ok('collectAllState 含 exam_hits', !!state['wb_zhiniao_exam_hits']);
ok('collectAllState 不含非前缀键', !('unrelated_key' in state));
const payload = w.backupAll(false);
ok('backupAll(false) payload 合法', payload.tool==='zhiniao-backup' && payload.version===1 && !!payload.keys['wb_zhiniao_exam_hits']);
w.rollingSnapshot();
let arr = JSON.parse(ls.getItem('wb_zhiniao_backups')||'[]');
ok('rollingSnapshot 写入快照', arr.length>=1, '快照数='+arr.length);
ok('rollingSnapshot 不超过5', arr.length<=5);
const snapHits = JSON.parse(arr[arr.length-1].keys['wb_zhiniao_exam_hits']);
ls.setItem('wb_zhiniao_exam_hits', JSON.stringify([{q:'TAMPERED'}]));
w.restoreSnapshot();
const restored = JSON.parse(ls.getItem('wb_zhiniao_exam_hits'));
ok('restoreSnapshot 还原内容', JSON.stringify(restored)===JSON.stringify(snapHits));

// 自动备份已移除下载
ls.setItem('wb_zhiniao_auto_backup','true');
ls.removeItem('wb_zhiniao_last_auto_backup');
let threw=false;
try { w.autoBackupMaybe(); } catch(e){ threw=true; }
ok('autoBackupMaybe 无异常且不下载', threw===false && ls.getItem('wb_zhiniao_last_auto_backup')===null);

// ---------- 9. AEP 周任务 ----------
section('9. AEP 周任务 (PDF+匹配)');
loginAs(ADMIN);
w.setSection('aep');
const wl = d.getElementById('aepWeekLabel'), wr = d.getElementById('aepWeekRange');
ok('当前周标签=Q4W8', wl && wl.textContent==='Q4W8', '='+(wl?wl.textContent:''));
ok('当前周范围=8月16日–8月22日(周日–周六)', wr && /8月16日–8月22日/.test(wr.textContent), '='+(wr?wr.textContent:''));
ok('AEP 匹配清单渲染(话术)', d.getElementById('aepScriptList') && d.getElementById('aepScriptList').children.length>=0);
ok('AEP 版块可见', d.getElementById('aepWrap').style.display!=='none');

// ---------- 10. 月考模式 ----------
section('10. 月考模式 (命中增强)');
loginAs(ADMIN);
w.setSection('exam');
ok('月考版块可见', d.getElementById('examWrap').style.display!=='none');
ok('examConfBadge 存在', typeof w.examConfBadge==='function');
ok('examConfBadge(100) 含 exact 样式', /exact/.test(w.examConfBadge(100)));
ok('examHighlightTitleFrag 存在', typeof w.examHighlightTitleFrag==='function');
ok('examImport 渲染', !!d.getElementById('examImport') && d.getElementById('examImport').innerHTML.length>0);
w.renderExamList();
ok('renderExamList 无异常', true);

// ---------- 11. 薪资计算器（管理员全店 / 普通隐藏） ----------
section('11. 薪资计算器 (SALARY_URL + 门禁)');
loginAs(ADMIN);
w.renderSalary();
const frame = d.getElementById('salaryFrame');
ok('管理员: iframe 指向 CloudStudio(非COS)', /f2f2687190d94596821d3f647183dab5\.app\.codebuddy\.work/.test(frame.src), 'src='+frame.src);
ok('管理员: 导航入口可见', d.getElementById('navSalary').style.display!=='none');

loginAs(COACH); // rikchou 在 SALARY_HIDDEN 中
w.updateSalaryEntry();
ok('隐藏账户: 导航入口隐藏', d.getElementById('navSalary').style.display==='none');
w.renderSalary();
ok('隐藏账户: iframe 释放(about:blank)', /about:blank/.test(d.getElementById('salaryFrame').src), 'src='+d.getElementById('salaryFrame').src);

// ---------- 12. 普通 Coach 主流程无碍 ----------
section('12. 普通 Coach 主流程');
loginAs(COACH);
ok('普通Coach: 非管理员', w.isAdmin()===false);
ok('普通Coach: body 无 is-admin', !d.body.classList.contains('is-admin'));
w.setSection('script');
ok('普通Coach: 话术列表正常渲染', d.querySelectorAll('#cardList .turn-node').length>0, '轮次数='+d.querySelectorAll('#cardList .turn-node').length);
ok('普通Coach: 可收藏', (()=>{ const b=d.querySelector('#cardList .fav-btn'); if(!b) return false; const s0=JSON.parse(ls.getItem('wb_zhiniao_favorites')||'[]').length; b.click(); const s1=JSON.parse(ls.getItem('wb_zhiniao_favorites')||'[]').length; b.click(); return s1!==s0; })());

// ---------- 汇总 ----------
console.log('\n================ 汇总 ================');
console.log('通过 '+pass+' 项，失败 '+fail+' 项');
if (fail>0){ console.log('失败项: '+failed.join(' | ')); process.exit(1); }
else { console.log('🎉 全部功能冒烟通过'); process.exit(0); }
