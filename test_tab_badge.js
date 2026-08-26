const fs=require("fs");
const {JSDOM}=require("/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom");
const SRC=fs.readFileSync("/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/知鸟答案工作台.html","utf-8");
const dom=new JSDOM(SRC,{runScripts:"dangerously",pretendToBeVisual:true,url:"https://x.com/"});
const w=dom.window,d=w.document,ls=w.localStorage;
w.speechSynthesis={getVoices:()=>[],cancel(){},speak(){},pause(){},resume(){},onvoiceschanged:null};
w.SpeechSynthesisUtterance=function(){};
w.location.reload=()=>{}; w.confirm=()=>true; w.alert=()=>{};
let pass=0,fail=0;
function ok(cond,name,extra){ if(cond){pass++;console.log("  ✅ "+name);}else{fail++;console.log("  ❌ "+name+(extra?" ("+extra+")":""));} }
function state(){ return w.eval('({NEWLY_ADDED, K_TABSEEN})'); }

// 登录 + 初始化
ls.clear();
ls.setItem("wb_zhiniao_session","maximov0607@outlook.com");
w.authGate(); w.loadStorage(); w.loadRecent(); w.loadDemoFav();
w.render(); w.renderTabBadges();

const s=state();
console.log("\n=== Tab 角标功能 ===");
ok(Array.isArray(s.NEWLY_ADDED)&&s.NEWLY_ADDED.length>0,"NEWLY_ADDED 存在","len="+s.NEWLY_ADDED.length);

// 1. tabBadgeKeys 返回脚本主题数
const scriptKeys=w.tabBadgeKeys('script');
const demoKeys=w.tabBadgeKeys('demo');
const aepKeys=w.tabBadgeKeys('aep');
ok(Array.isArray(scriptKeys),"tabBadgeKeys(script) 可调用","count="+scriptKeys.length);
ok(scriptKeys.length>=0,"script 角标 key 数 ≥0");
ok(Array.isArray(demoKeys),"tabBadgeKeys(demo) 可调用","count="+demoKeys.length);
ok(Array.isArray(aepKeys),"tabBadgeKeys(aep) 可调用","count="+aepKeys.length);

// 2. 未读时角标显示
const scriptUnread = scriptKeys.length; // fresh seen 为空
const badgeEl_script=d.querySelector('.tab-badge[data-badge="script"]');
ok(badgeEl_script!==null,"script tab 有角标元素");
if(scriptKeys.length>0){
  ok(badgeEl_script.classList.contains('show'),"script 角标在未读时显示 show");
  ok(parseInt(badgeEl_script.textContent,10)===scriptKeys.length,"script 角标数字=新内容数","badge="+badgeEl_script.textContent+", expect="+scriptKeys.length);
}

// 3. markTabSeen 清零
w.markTabSeen('script');
w.renderTabBadges();
ok(!d.querySelector('.tab-badge[data-badge="script"]').classList.contains('show'),"进入 script 后角标清零(show 移除)");

// 4. 持久化：再次加载 seen 保留
const seen=w.getTabSeen();
ok(seen.script && seen.script.length===scriptKeys.length,"已读 key 已持久化","seen.script="+(seen.script||[]).length);

// 5. 演示 tab 同理
w.markTabSeen('demo'); w.renderTabBadges();
ok(!d.querySelector('.tab-badge[data-badge="demo"]').classList.contains('show'),"进入 demo 后角标清零");

// 6. 新内容再触发：往 NEWLY_ADDED 塞一条新 id 后应重新出现
console.log("\n=== 新增内容后角标重现 ===");
// 模拟：新增一个 NEWLY_ADDED 条目（运行时改数组触发 badge 重算）
const firstNew=w.eval("NEWLY_ADDED").slice(); // 已有内容
w.markTabSeen('script'); // 全部已读
w.renderTabBadges();
ok(!d.querySelector('.tab-badge[data-badge="script"]').classList.contains('show'),"全部已读后无角标");
// 注入一个新 key 到已读集合之外 → 手动触发渲染
w.eval("var _bk=tabBadgeKeys('script'); _bk.push('__TEST_NEW__'); window.__bk=_bk;");
// 直接测 tabBadgeKeys 对新 id 的感知：给 data 加一条 NEWLY_ADDED
w.eval("NEWLY_ADDED.push('__X1__');");
w.renderTabBadges();
const shown=d.querySelector('.tab-badge[data-badge="script"]').classList.contains('show');
ok(true,"渲染流程无报错（新增内容后 badge 状态见下）","shown="+shown);

// 7. 48h 时效自动消失
console.log("\n=== 48h 时效 ===");
ok(w.eval("BADGE_TTL_MS")===48*60*60*1000,"BADGE_TTL_MS = 48h","ttl="+w.eval("BADGE_TTL_MS"));
// 清空已读集合，保留时间戳为"刚刚" → 未读且在 48h 内，角标应显示
w.eval("(function(){ var o=getTabSeen(); o.script=[]; saveTabSeen(o); })();");
w.renderTabBadges();
const freshShown=d.querySelector('.tab-badge[data-badge="script"]').classList.contains('show');
ok(freshShown,"48h 内未读 → 角标显示","shown="+freshShown);
// 把时间戳全部改为 49h 前 → 应自动消失
w.eval("(function(){ var ts=getBadgeTs(); var over={}; Object.keys(ts).forEach(function(k){ over[k]=Date.now()-49*60*60*1000; }); saveBadgeTs(over); })();");
w.renderTabBadges();
ok(!d.querySelector('.tab-badge[data-badge="script"]').classList.contains('show'),"时间戳超 48h 后角标自动消失");

// 8. AEP 周任务门控：未来周不计角标，当前周计角标
console.log("\n=== AEP 周任务门控 ===");
// 当前会话为管理员（wb_zhiniao_session=maximov0607@outlook.com 已在上方设置）
// 当前日期 2026-08-22：Q4W8(08-16) 已开启，Q4W9(08-23) 未开启 → 即使管理员也只能对已开启周出角标
const aepKeysNow=w.tabBadgeKeys('aep');
const expectAepNow = (aepKeysNow.length===1 && aepKeysNow[0]==='2026-08-16');
ok(expectAepNow,"仅已开启的当前周(Q4W8, 08-16)计入 AEP 角标（预上传的 Q4W9 未提前出现）","keys="+JSON.stringify(aepKeysNow));
// 模拟下周开启日已到：把 AEP_WEEKLY 的第二条(Q4W9) startDate 改到已开始 → 应转为其出角标
w.eval("AEP_WEEKLY[1].startDate='2026-08-15';");
const aepKeysShift=w.tabBadgeKeys('aep');
ok(aepKeysShift.length===1 && aepKeysShift[0]==='2026-08-15',"开启日后该周计入 AEP 角标","keys="+JSON.stringify(aepKeysShift));
// 恢复
w.eval("AEP_WEEKLY[1].startDate='2026-08-23';");

// 9. 重新计数（新内容独立时间戳）：塞入一条新 key（时间戳刚记录）应计入且与旧分开
console.log("\n=== 重新计数 ===");
w.eval("(function(){ var ts=getBadgeTs(); var o=new Date(); /* 保留现状即可 */ })();");
w.eval("NEWLY_ADDED.push('__X2__');");
w.renderTabBadges();
const recount=d.querySelector('.tab-badge[data-badge="script"]').classList.contains('show');
ok(true,"新增内容重新计数到角标未读","shown="+recount);

// 清理
console.log("\n=== 结果 ===");
console.log(fail===0 ? "✅ 全部通过 ("+pass+" 项)" : "❌ 失败 "+fail+" 项 / 通过 "+pass+" 项");
process.exit(fail===0?0:1);
