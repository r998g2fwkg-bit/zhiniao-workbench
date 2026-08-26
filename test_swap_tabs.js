const fs = require('fs');
const { JSDOM } = require('jsdom');
const path = require('path');

const root = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01';
const files = ['知鸟答案工作台.html', 'dist/index.html', 'dist/index.static.html'];

for (const f of files) {
  const fp = path.join(root, f);
  const html = fs.readFileSync(fp, 'utf-8');
  const dom = new JSDOM(html, { runScripts: 'outside-only' });
  const doc = dom.window.document;
  const tabs = doc.querySelectorAll('#sectionTabs .sec-tab');
  const order = Array.from(tabs).map(b => b.dataset.sec);
  console.log(`${f}: ${order.join(', ')}`);
  if (order.join(',') !== 'script,demo,aep,exam') {
    throw new Error(`${f}: unexpected tab order`);
  }
  // Verify labels
  const labels = Array.from(tabs).map(b => b.textContent.trim());
  console.log(`  labels: ${labels.join(' | ')}`);
}

// JS syntax check: extract inline scripts and new Function them
for (const f of files) {
  const fp = path.join(root, f);
  const html = fs.readFileSync(fp, 'utf-8');
  const dom = new JSDOM(html, { runScripts: 'outside-only' });
  const scripts = dom.window.document.querySelectorAll('script:not([src])');
  let idx = 0;
  for (const s of scripts) {
    const code = s.textContent;
    if (!code.trim()) continue;
    try {
      new Function(code);
    } catch (e) {
      throw new Error(`${f}: inline script #${idx} syntax error: ${e.message}`);
    }
    idx++;
  }
  console.log(`${f}: ${idx} inline scripts syntax OK`);
}

console.log('All checks passed.');
