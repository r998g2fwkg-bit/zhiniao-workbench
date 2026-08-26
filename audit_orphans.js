const fs = require("fs");
const path = require("path");

// htmlFile: the HTML whose DEMO_DATA is the source of truth
// assetBaseDir: the on-disk assets root (e.g. "dist/assets" or "assets")
// refStrip: prefix to remove from refs so they align with disk-relative paths
function audit(htmlFile, assetBaseDir, refStrip) {
  const s = fs.readFileSync(htmlFile, "utf8");
  const refs = new Set();
  const d = s.indexOf("const DEMO_DATA=[");
  const a = s.indexOf("[", d);
  let depth = 0, inS = false, esc = false;
  for (let i = a; i < s.length; i++) {
    const c = s[i];
    if (inS) { if (esc) esc = false; else if (c === "\\") esc = true; else if (c === "\"") inS = false; }
    else { if (c === "\"") inS = true; else if (c === "[") depth++; else if (c === "]") { depth--; if (depth === 0) { var arr = JSON.parse(s.slice(a, i + 1)); break; } } }
  }
  arr.forEach(x => (x.demoImages || []).forEach(p => refs.add(p.replace(refStrip, ""))));
  (s.match(/assets\/avatars\/[^\"']+|assets\/exam\/[^\"']+/g) || []).forEach(p => refs.add(p.replace(refStrip, "")));

  const disk = new Set();
  (function walk(dir) {
    for (const f of fs.readdirSync(dir)) {
      const fp = path.join(dir, f);
      if (fs.statSync(fp).isDirectory()) walk(fp);
      else disk.add(path.relative(assetBaseDir, fp).split(path.sep).join("/"));
    }
  })(assetBaseDir);

  const orphans = [...disk].filter(f => !refs.has(f)).sort();
  const missing = [...refs].filter(f => !disk.has(f)).sort();
  let bytes = 0;
  orphans.forEach(o => { try { bytes += fs.statSync(path.join(assetBaseDir, o)).size; } catch (e) {} });
  console.log(`\n### ${htmlFile}  ->  ${assetBaseDir}`);
  console.log(`    referenced=${refs.size} onDisk=${disk.size} orphans=${orphans.length} missing=${missing.length} orphanSize=${(bytes/1024).toFixed(1)}KB`);
  if (missing.length) console.log("    !! MISSING (would break):", missing.slice(0, 10).join(", "), missing.length > 10 ? "..." : "");
  return { orphans, assetBaseDir };
}

const targets = [
  audit("dist/index.html", "dist/assets", /^assets\//),
  audit("知鸟答案工作台.html", "assets", /^assets\//),
];

if (process.argv.includes("--delete")) {
  let total = 0;
  for (const { orphans, assetBaseDir } of targets) {
    for (const o of orphans) {
      const fp = path.join(assetBaseDir, o);
      try { fs.unlinkSync(fp); total++; } catch (e) { console.log("    delete failed:", o, e.message); }
    }
  }
  console.log(`\nDELETED ${total} orphan files.`);
} else {
  console.log("\n[DRY-RUN] pass --delete to actually remove orphans.");
}
