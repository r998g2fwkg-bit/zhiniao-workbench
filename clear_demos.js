const fs = require("fs");
const path = require("path");

const ROOT = "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01";
const FILES = [
  path.join(ROOT, "知鸟答案工作台.html"),
  path.join(ROOT, "dist/index.html"),
  path.join(ROOT, "dist/index.static.html"),
];
const CLEAR_IDS = ["demo37", "demo38", "demo39"];

function extractArray(s, marker) {
  const d = s.indexOf(marker);
  if (d < 0) return null;
  const a = s.indexOf("[", d);
  let depth = 0, inS = false, esc = false;
  for (let i = a; i < s.length; i++) {
    const c = s[i];
    if (inS) { if (esc) esc = false; else if (c === "\\") esc = true; else if (c === '"') inS = false; }
    else { if (c === '"') inS = true; else if (c === "[") depth++; else if (c === "]") { depth--; if (depth === 0) return { declStart: d, arrStart: a, arrEnd: i }; } }
  }
  return null;
}
function replaceArray(s, info, newArr) {
  const prefix = s.slice(info.declStart, info.arrStart);
  return s.slice(0, info.declStart) + prefix + JSON.stringify(newArr) + s.slice(info.arrEnd + 1);
}

for (const f of FILES) {
  if (!fs.existsSync(f)) { console.log("SKIP (missing):", f); continue; }
  let s = fs.readFileSync(f, "utf8");
  const info = extractArray(s, "const DEMO_DATA=[");
  if (!info) { console.log("DEMO_DATA not found in", f); continue; }
  const arr = JSON.parse(s.slice(info.arrStart, info.arrEnd + 1));
  const byId = {}; arr.forEach((e, i) => byId[e.id] = i);
  const report = [];
  for (const id of CLEAR_IDS) {
    const idx = byId[id];
    if (idx === undefined) { report.push(`! ${id} 源中不存在`); continue; }
    const e = arr[idx];
    e.intro = "";
    e.segments = [];
    e.demoImages = [];
    e.status = "active"; // 保留卡片可见
    report.push(`✎ ${id} (${e.sheet} / ${e.topic}) 内容已清空，卡片保留`);
  }
  s = replaceArray(s, info, arr);
  fs.writeFileSync(f, s, "utf8");
  console.log("## " + path.basename(f));
  report.forEach(r => console.log("  " + r));
}
console.log("DONE");
