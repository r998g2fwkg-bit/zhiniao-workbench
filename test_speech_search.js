const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const src = fs.readFileSync(path.join(root, '知鸟答案工作台.html'), 'utf-8');
const dom = new JSDOM(src, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
const w = dom.window;

function assert(c, m){ if(!c) throw new Error('FAIL: '+m); console.log('OK '+m); }

// ---- searchHit 容错 ----
assert(w.searchHit('iPhone 17 的电池容量是多少', 'iphone17电池') === true, '去空格+子序列：iphone17电池 命中 iPhone 17 的电池容量');
assert(w.searchHit('iPhone 17 的电池容量是多少', '电池 容量') === true, '多词 AND：电池 容量 命中');
assert(w.searchHit('如何激活 iPhone', '激活') === true, '连续子串：激活 命中');
assert(w.searchHit('如何激活 iPhone', 'xyz不存在') === false, '无关词不命中');
assert(w.searchHit('以旧换新怎么算价', '以旧 换新') === true, '多词 AND：以旧 换新 命中');
assert(w.searchHit('MacBook Air M2 续航', 'macbookairm2续航') === true, '全拼连写命中');
assert(w.searchHit('', '随便') === false, '空 haystack + 非空 query => 不命中');
assert(w.searchHit('演示主题', '') === true, '空 query 恒命中');

// ---- speechHasZh / speechWarnNoZh ----
// jsdom 无 Web Speech API，手动打桩
w.speechSynthesis = { getVoices: () => [], cancel(){}, speak(){}, pause(){}, resume(){}, onvoiceschanged:null };
w.SpeechSynthesisUtterance = function(){};
const st = w.document.getElementById('speechStatus');
const bar = w.document.getElementById('speechBar');

// 模拟无中文语音环境
w.speechSynthesis.getVoices = () => [];
assert(w.speechHasZh() === false, 'speechHasZh 空列表=false');
w.speechWarnNoZh();
assert(/未检测到中文语音/.test(st.textContent), '无中文语音时状态文案更新');
assert(st.classList.contains('no-zh'), '无中文语音时状态加 no-zh');
assert(bar.classList.contains('no-zh'), '无中文语音时 speechBar 加 no-zh');

// 模拟有中文语音
w.speechSynthesis.getVoices = () => [{name:'Ting-Ting', lang:'zh-CN'}];
assert(w.speechHasZh() === true, 'speechHasZh 含 zh=true');
w.speechWarnNoZh();
assert(!st.classList.contains('no-zh'), '有中文语音时移除 no-zh');

console.log('ALL SPEECH/SEARCH TESTS PASSED');
