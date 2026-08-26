// 集成测试：在 jsdom 中加载整页，驱动月考命中记录逻辑
const fs = require("fs");
const { JSDOM } = require("/Users/zhoujiale/.workbuddy/binaries/node/workspace/node_modules/jsdom");

const html = fs.readFileSync("知鸟答案工作台.html", "utf8");
const errors = [];
const dom = new JSDOM(html, {
  runScripts: "dangerously",
  url: "http://localhost/",
  pretendToBeVisual: true,
  beforeParse(window) {
    window.confirm = () => true;
    window.showToast = () => {};
  },
});
const { window } = dom;
window.addEventListener("error", (e) => errors.push("window error: " + (e.error && e.error.stack || e.message)));

// 等待内联脚本执行（脚本为同步，但 DOMContentLoaded 可能异步）
setTimeout(() => {
  try {
    const w = window;
    // 进入月考模式
    if (typeof w.renderExam === "function") w.renderExam();
    if (typeof w.examSelectType !== "function") throw new Error("examSelectType 不存在");
    w.examSelectType("coach");
    const ta = w.document.getElementById("examPaste");
    if (!ta) throw new Error("examPaste 未注入");
    // 一道应命中（诚意满满 是已知话术）、一道乱码必未命中
    ta.value = "1. 诚意满满\n2. zxqwlkjasd乱码不存在xyz";
    if (typeof w.examDoParse !== "function") throw new Error("examDoParse 不存在");
    w.examDoParse(false);

    const hits = JSON.parse(w.localStorage.getItem("wb_zhiniao_exam_hits") || "[]");
    const gaps = JSON.parse(w.localStorage.getItem("wb_zhiniao_exam_gaps") || "[]");
    console.log("HITS 条数:", hits.length, hits[0] ? JSON.stringify(hits[0]).slice(0,120) : "");
    console.log("GAPS 条数:", gaps.length, gaps[0] ? JSON.stringify(gaps[0]).slice(0,120) : "");

    // 面板渲染
    const box = w.document.getElementById("examHitLog");
    const html2 = box ? box.innerHTML : "(无节点)";
    console.log("面板含 命中率:", html2.includes("命中率"));
    console.log("面板含 待补:", html2.includes("待补"));
    console.log("面板含 复制待补清单按钮:", html2.includes("examCopyGaps"));

    // 去重：再次解析同样内容，不应新增
    w.examDoParse(false);
    const hits2 = JSON.parse(w.localStorage.getItem("wb_zhiniao_exam_hits") || "[]");
    const gaps2 = JSON.parse(w.localStorage.getItem("wb_zhiniao_exam_gaps") || "[]");
    console.log("去重后 HITS:", hits2.length, "GAPS:", gaps2.length);

    // 清空交接不应误伤记录
    w.examClearSession();
    const hits3 = JSON.parse(w.localStorage.getItem("wb_zhiniao_exam_hits") || "[]");
    const gaps3 = JSON.parse(w.localStorage.getItem("wb_zhiniao_exam_gaps") || "[]");
    console.log("清空后 HITS(应保留):", hits3.length, "GAPS(应保留):", gaps3.length);

    console.log("ERRORS:", errors.length ? errors.join("\n") : "none");
    console.log("RESULT:", (hits.length===1 && gaps.length===1 && hits2.length===1 && gaps2.length===1 && hits3.length===1 && gaps3.length===1 && html2.includes("命中率")) ? "PASS" : "FAIL");
  } catch (e) {
    console.error("TEST EXCEPTION:", e.stack);
    process.exit(1);
  }
}, 600);
