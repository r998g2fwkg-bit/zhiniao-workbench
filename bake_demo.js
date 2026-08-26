const fs = require("fs");
const path = require("path");

const ROOT = "/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01";
const FILES = [
  path.join(ROOT, "知鸟答案工作台.html"),
  path.join(ROOT, "dist/index.html"),
  path.join(ROOT, "dist/index.static.html"),
];
const DRAFT = process.argv[2] || "/Users/zhoujiale/Downloads/zhiniao-bake-draft-2026-08-12 (2).json";

// ---- bracket-matching extractor for a JSON-style array starting at first '[' after pos
function extractArray(s, startMarker) {
  const declStart = s.indexOf(startMarker);
  if (declStart < 0) return null;
  const arrStart = s.indexOf("[", declStart);
  if (arrStart < 0) return null;
  let depth = 0, inStr = false, esc = false;
  for (let i = arrStart; i < s.length; i++) {
    const c = s[i];
    if (inStr) {
      if (esc) esc = false;
      else if (c === "\\") esc = true;
      else if (c === '"') inStr = false;
    } else {
      if (c === '"') inStr = true;
      else if (c === "[") depth++;
      else if (c === "]") { depth--; if (depth === 0) return { declStart, arrStart, arrEnd: i }; }
    }
  }
  return null;
}

function replaceArray(s, info, newArr) {
  const prefix = s.slice(info.declStart, info.arrStart); // includes "const X=["
  return s.slice(0, info.declStart) + prefix + JSON.stringify(newArr) + s.slice(info.arrEnd + 1);
}

function deepEq(a, b) {
  return JSON.stringify(a) === JSON.stringify(b);
}

const draft = JSON.parse(fs.readFileSync(DRAFT, "utf8"));
const changes = {}; // file -> list

for (const f of FILES) {
  if (!fs.existsSync(f)) { console.log("SKIP (missing):", f); continue; }
  let s = fs.readFileSync(f, "utf8");
  const info = extractArray(s, "const DEMO_DATA=[");
  if (!info) { console.log("DEMO_DATA not found in", f); continue; }
  const arr = JSON.parse(s.slice(info.arrStart, info.arrEnd + 1));
  const byId = {};
  arr.forEach((e, i) => { byId[e.id] = i; });

  const fileChanges = [];
  for (const [id, ov] of Object.entries(draft.demoOverrides || {})) {
    const idx = byId[id];
    if (idx === undefined) { fileChanges.push(`! ${id} 源中不存在，跳过`); continue; }
    const cur = arr[idx];
    // compare each override field
    let diff = false;
    const fieldDiffs = [];
    for (const k of Object.keys(ov)) {
      if (!deepEq(cur[k], ov[k])) { diff = true; fieldDiffs.push(k); }
    }
    if (diff) {
      arr[idx] = Object.assign({}, cur, ov);
      fileChanges.push(`✎ ${id} 更新字段: ${fieldDiffs.join(", ")}`);
    } else {
      fileChanges.push(`· ${id} 无变化`);
    }
  }

  // GLOBAL_ARCHIVED bake (idempotent)
  const gaInfo = extractArray(s, "GLOBAL_ARCHIVED = [");
  if (gaInfo) {
    const ga = JSON.parse(s.slice(gaInfo.arrStart, gaInfo.arrEnd + 1));
    const set = new Set(ga);
    let added = 0;
    for (const k of (draft.archivedKeys || [])) {
      if (!set.has(k)) { ga.push(k); set.add(k); added++; }
    }
    if (added) { s = replaceArray(s, gaInfo, ga); fileChanges.push(`✎ GLOBAL_ARCHIVED +${added} 条`); }
    else fileChanges.push(`· GLOBAL_ARCHIVED 无变化`);
  }

  s = replaceArray(s, info, arr);
  fs.writeFileSync(f, s, "utf8");
  changes[f] = fileChanges;
}

console.log("===== Bake report =====");
for (const f of FILES) {
  if (!changes[f]) continue;
  console.log("\n## " + path.basename(f));
  changes[f].forEach(c => console.log("  " + c));
}
console.log("\nDONE");
