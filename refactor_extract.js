#!/usr/bin/env node
/*
 * 3C 数据抽离 · 一次性抽取脚本 (refactor_extract.js)
 * 读取当前源 HTML，以 JS 引擎 eval 精确抽取 12 个数据常量，
 *   - 写入 data/app_data.json（可编辑真源）
 *   - 生成 src/知鸟答案工作台.template.html（单注入点 __APP_DATA_JSON__）
 * 之后三端由 build.py 从 app_data.json 烘焙生成。
 */
const fs = require('fs');
const path = require('path');

const ROOT = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const SRC = path.join(ROOT, '知鸟答案工作台.html');
const DATA_DIR = path.join(ROOT, 'data');
const SRC_DIR = path.join(ROOT, 'src');
const OUT_JSON = path.join(DATA_DIR, 'app_data.json');
const OUT_TPL = path.join(SRC_DIR, '知鸟答案工作台.template.html');

let html = fs.readFileSync(SRC, 'utf8');

// 抽取规范：name + 原声明关键字(const/let)
const SPECS = [
  { name: 'RAW_DATA', kind: 'const' },
  { name: 'DEMO_DATA', kind: 'const' },
  { name: 'NOTICES', kind: 'let' },
  { name: 'AEP_WEEKLY', kind: 'const' },
  { name: 'CHANGELOG', kind: 'const' },
  { name: 'GLOBAL_ARCHIVED', kind: 'const' },
  { name: 'SEED_EMAILS', kind: 'const' },
  { name: 'SALARY_HIDDEN_EMAILS', kind: 'const' },
  { name: 'SALARY_STORE_MAP', kind: 'const' },
  { name: 'SALARY_PIN_MAP', kind: 'const' },
  { name: 'ADMIN_EMAIL', kind: 'const' },
  { name: 'SALARY_URL', kind: 'const' },
];

// 在 html 中定位某常量的声明范围，平衡括号抽取 RHS 文本
function findDecl(h, name) {
  const re = new RegExp('(?:const|let)\\s+' + name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\s*=\\s*');
  const m = re.exec(h);
  if (!m) throw new Error('未找到声明: ' + name);
  const declStart = m.index;
  const rhsStart = m.index + m[0].length;
  let depth = 0, inStr = null;
  let k = rhsStart;
  for (; k < h.length; k++) {
    const c = h[k];
    if (inStr) {
      if (c === '\\') { k++; continue; }      // 跳过转义字符
      if (c === inStr) { inStr = null; continue; }
    } else {
      if (c === '"' || c === "'" || c === '`') { inStr = c; continue; }
      if (c === '[' || c === '{' || c === '(') { depth++; continue; }
      if (c === ']' || c === '}' || c === ')') { depth--; continue; }
      if (depth === 0 && c === ';') break;     // 顶层分号 = 声明结束
    }
  }
  const end = k; // 分号下标
  const rhsText = h.slice(rhsStart, end);
  const fullText = h.slice(declStart, end + 1);
  return { declStart, declEnd: end + 1, rhsText, fullText };
}

// 抽取所有常量值
const appData = {};
for (const s of SPECS) {
  const d = findDecl(html, s.name);
  let val;
  try {
    val = eval('(' + d.rhsText + ')');
  } catch (e) {
    throw new Error('eval 失败 [' + s.name + ']: ' + e.message);
  }
  appData[s.name] = val;
  console.log(`  [抽取] ${s.name}: ${Array.isArray(val) ? val.length + ' 项' : typeof val}`);
}

// 写 data/app_data.json（紧凑，确保非 ASCII 直接输出中文）
fs.mkdirSync(DATA_DIR, { recursive: true });
fs.writeFileSync(OUT_JSON, JSON.stringify(appData, null, 0), 'utf8');
console.log(`\n  [写出] ${OUT_JSON}  (${fs.statSync(OUT_JSON).size} bytes)`);

// ---- 生成模板 ----
// 1) 在主 <script> 前插入数据脚本（单注入点）
const anchor = html.match(/<script>\s*const RAW_DATA/);
if (!anchor) throw new Error('未定位主 <script> 注入锚点');
const scriptStart = anchor.index;
const dataScript = '<script>\nwindow.__APP_DATA__ = __APP_DATA_JSON__;\n</script>\n\n';
let tpl = html.slice(0, scriptStart) + dataScript + html.slice(scriptStart);

// 2) 把每个声明替换为引用 window.__APP_DATA__.<NAME>
for (const s of SPECS) {
  const d = findDecl(tpl, s.name);
  const newDecl = `${s.kind} ${s.name} = window.__APP_DATA__.${s.name};`;
  tpl = tpl.slice(0, d.declStart) + newDecl + tpl.slice(d.declEnd);
  console.log(`  [模板] ${s.name} -> ${newDecl}`);
}

fs.mkdirSync(SRC_DIR, { recursive: true });
fs.writeFileSync(OUT_TPL, tpl, 'utf8');
console.log(`\n  [写出] ${OUT_TPL}  (${fs.statSync(OUT_TPL).size} bytes)`);
console.log('\n✅ 抽取 + 模板生成完成。下一步运行 build.py 生成三端产物。');
