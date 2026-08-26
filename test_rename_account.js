const fs = require('fs');
const path = require('path');
const { JSDOM } = require('/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const files = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html'];

// 1) 静态结构校验三端
files.forEach(f => {
  const html = fs.readFileSync(path.join(root, f), 'utf-8');
  const dom = new JSDOM(html);
  const doc = dom.window.document;
  const name = doc.getElementById('accountName');
  const type = doc.getElementById('accountType');
  if (!name || !type) throw new Error(`${f}: accountName/accountType missing`);
  console.log(`${f}: static OK (accountName & accountType present)`);
});

// 2) 逻辑校验（源文件，dangerously 执行内联脚本）
const src = fs.readFileSync(path.join(root, '知鸟答案工作台.html'), 'utf-8');
const dom = new JSDOM(src, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://example.com/' });
const w = dom.window;

const testName = w.userName('rikchou@icloud.com');
if (testName !== 'Onezero长沙河西王府井店') throw new Error('userName wrong: ' + testName);
// 测试账户应「看不到薪资入口」(canSeeSalary=false)；普通门店账户应能看到
const rikHidden = !w.canSeeSalary('rikchou@icloud.com');
if (!rikHidden) throw new Error('rikchou must remain a test account (hidden from salary)');
const normalVisible = w.canSeeSalary('927699803@qq.com');
if (!normalVisible) throw new Error('normal store account must see salary');
console.log('LOGIC: rikchou displayName =', testName, '| still test account (salary hidden) =', rikHidden);
console.log('LOGIC: normal store account sees salary =', normalVisible);
console.log('ALL ACCOUNT TESTS PASSED');
