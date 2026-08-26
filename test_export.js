const fs = require('fs');
const { JSDOM } = require('jsdom');

const html = fs.readFileSync('知鸟答案工作台.html', 'utf8');
const dom = new JSDOM(html, { runScripts: 'dangerously', pretendToBeVisual: true, url: 'https://localhost/' });
const w = dom.window;

setTimeout(() => {
  try {
    // 确保进入月考模式并选 coach 类型
    if (typeof w.renderExam === 'function') w.renderExam();
    w.examSelectType('coach');
    const ta = w.document.getElementById('examPaste');
    ta.value = '这是一道完全匹配不到任何话术的乱码题目XYZ123测试导出';
    w.examDoParse();
    w.renderExamHitLog();

    const exp = w.document.getElementById('examExportGaps');
    const cp = w.document.getElementById('examCopyGaps');
    console.log('exportBtn exists:', !!exp);
    console.log('copyBtn exists:', !!cp);
    console.log('exportBtn disabled:', exp ? exp.disabled : 'n/a');
    console.log('export onclick is function:', exp ? (typeof exp.onclick === 'function') : 'n/a');
    console.log('actions container exists:', !!w.document.querySelector('.exam-gap-actions'));
    console.log('gapList length:', JSON.parse(w.localStorage.getItem('wb_zhiniao_exam_gaps')||'[]').length);
    process.exit(0);
  } catch (e) {
    console.error('ERR', e);
    process.exit(1);
  }
}, 600);
