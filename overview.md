# 3C 数据抽离为独立 JSON include — 完成总览

## 目标
把嵌在六千行 HTML 里的所有「内容数据常量」抽成独立 `data/app_data.json`，降低「改数据手滑焊崩整页」的风险，让系统长期更稳定。

## 方案（关键决策）
**构建期内联注入** —— 既拿到「数据与代码分离」的好处，又**不改变部署产物的形态与你的使用方式**：
- 真源：`data/app_data.json`（12 个键）
- 模板：`src/知鸟答案工作台.template.html`（声明改为 `const RAW_DATA = window.__APP_DATA__.RAW_DATA;` 引用形式，单注入点 `__APP_DATA_JSON__`）
- `build.py`：把 JSON 注入占位点 → 生成三端字节一致的单文件 HTML
- **部署产物仍是单文件、零运行时 fetch** → 你打开/刷新方式与之前完全一样

## 抽出的 12 个常量
RAW_DATA(197) / DEMO_DATA(40) / NOTICES(2) / AEP_WEEKLY(2) / CHANGELOG(5) / GLOBAL_ARCHIVED(10) / SEED_EMAILS(6) / SALARY_HIDDEN_EMAILS(1) / SALARY_STORE_MAP(5) / SALARY_PIN_MAP(5) / ADMIN_EMAIL / SALARY_URL

## 验证结果
- ✅ `release_check.py` 现 **15 类断言**（新增 [15] 数据抽离完整性），262 OK / 0 失败
- ✅ Node 解析注入 blob：12 键齐全、计数正确、无 `</script>` 提前闭合风险
- ✅ `build.py` 重跑幂等（三端 md5 不变 `7cb727e7…`），RAW_DATA=197
- ✅ 数据脚本在主脚本之前独立执行，引用顺序安全

## 你的新工作流（不变的手感）
发需求 → 我改 `data/app_data.json` → `build.py` → 重部署（链接不变，你刷新即用）。

## 当前状态
- 代码全部就绪并通过本地全量验证。
- **部署**：CloudStudio 平台 API 连续 3 次 `fetch failed`（网络层抖动，非代码问题），待重试。线上当前仍跑上一版（管理员可见性版），功能正常不受影响。

## 相关文件
- `data/app_data.json` — 数据真源（以后改内容只动这里）
- `src/知鸟答案工作台.template.html` — HTML 模板（改程序逻辑才动这里）
- `build.py` — JSON → 三端烘焙
- `refactor_extract.js` — 一次性抽取脚本（已用，留档）
- `release_check.py` — 发布门禁（含 [15] 数据抽离完整性）
