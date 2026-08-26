# 知鸟答案工作台 — 后端化改造技术方案

> 版本：v2.0 | 日期：2026-08-24 | 状态：**已审阅通过，启动 Phase 1**

---

## 一、决策摘要

| 决策项 | 选择 |
|--------|------|
| 交付节奏 | 分阶段，4 个 Phase，每阶段独立验证 |
| 数据迁移 | 全量导入 D1 + 保留 HTML 兜底（双链路，可回滚） |
| 鉴权方案 | 邮箱 + 密码登录 + JWT |
| 编辑入口 | 独立 `/admin` 路由 + 前台快捷编辑按钮 |

---

## 二、架构总览

```
┌─────────────────────────────────────────────────────────────┐
│  CloudBase 主站        │    Cloudflare Pages 备用站            │
│  *.tcloudbaseapp.com  │    *.pages.dev                       │
│  （同一片 HTML 产物） │                                      │
└────────────┬────────────┬───────────────────────────────────┘
             │            │
             │   fetch()  │  CORS 放行双域名
             └─────┬──────┘
                   ▼
         ┌──────────────────────┐
         │  Cloudflare Workers  │
         │  API 路由表          │
         │  /api/scripts        │
         │  /api/demos          │
         │  /api/notices        │
         │  /api/learning       │
         │  /api/auth           │
         └──────────┬───────────┘
                    │
                    ▼
         ┌──────────────────────┐
         │  Cloudflare D1       │
         │  SQLite 数据库        │
         │  唯一数据源           │
         └──────────────────────┘
```

### 核心原则
- **主链接不变**：CloudBase 域名继续作为生产入口
- **双站共用后端**：workers.dev 子域名或自定义域名暴露 API
- **彻底移除 localStorage**：所有数据读写走 API（仅 `jwt_token` 存 localStorage，可换其他方式）
- **零成本**：Workers + D1 免费额度远超项目需求

---

## 三、D1 数据库设计

### 3.1 数据表结构

```sql
-- 话术表（对应 RAW_DATA）
CREATE TABLE scripts (
  id          TEXT PRIMARY KEY,
  sheet       TEXT NOT NULL,
  category    TEXT NOT NULL,
  topic       TEXT NOT NULL,
  turn        INTEGER NOT NULL DEFAULT 1,
  is_follow_up INTEGER NOT NULL DEFAULT 0,
  question    TEXT,
  answer      TEXT,
  keywords    TEXT,
  created_at  TEXT NOT NULL,
  status      TEXT NOT NULL DEFAULT 'active'  -- active | archived
);

-- 演示表（对应 DEMO_DATA）
CREATE TABLE demos (
  id          TEXT PRIMARY KEY,
  sheet       TEXT,
  topic       TEXT,
  status      TEXT DEFAULT 'active',
  category    TEXT,
  demo_type   TEXT,
  intro       TEXT,
  demo_images TEXT  -- JSON 数组，路径列表
);

-- 通知表（对应 NOTICES）
CREATE TABLE notices (
  id        TEXT PRIMARY KEY,
  level     TEXT NOT NULL,  -- info | warning | alert | important
  date      TEXT NOT NULL,
  sticky    INTEGER NOT NULL DEFAULT 0,
  title     TEXT NOT NULL,
  body      TEXT,
  image     TEXT  -- 相对路径，可为 NULL
);

-- 学习记录表（新模块，之前无后端存储）
CREATE TABLE learning_records (
  id          TEXT PRIMARY KEY,  -- 格式: {email}_exam_{YYYYMMDD}
  email       TEXT NOT NULL,
  kind        TEXT NOT NULL,     -- coach | demo
  exam_date   TEXT NOT NULL,
  score       INTEGER,
  total       INTEGER,
  answers     TEXT,  -- JSON: {question_id: user_answer}
  created_at  TEXT NOT NULL
);

-- ⚠️ 普通用户风险备注：
-- 当前版本无普通用户注册登录体系，用户身份由前端提交 email 标识，
-- 仅适合小范围内部使用；未来面向更多用户时，需补充普通账号鉴权机制，
-- 防止越权篡改他人学习记录。

-- 月考记录表（对应 EXAM_SCHEDULE 的命中/未命中跟踪）
CREATE TABLE exam_hits (
  id          TEXT PRIMARY KEY,
  email       TEXT NOT NULL,
  exam_id     TEXT NOT NULL,
  script_id   TEXT NOT NULL,
  is_correct  INTEGER NOT NULL,  -- 1=正确 0=错误
  recorded_at TEXT NOT NULL
);

-- 管理员表
CREATE TABLE admins (
  email       TEXT PRIMARY KEY,
  password_hash TEXT NOT NULL,
  created_at  TEXT NOT NULL
);
```

### 3.2 初始数据导入

```
RAW_DATA (200条)   → scripts 表
DEMO_DATA (40条)   → demos 表
NOTICES (3条)      → notices 表
SEED_EMAILS (6个)  → admins 表（密码由管理员在首次登录后设置）
AEP_WEEKLY (2条)   → 存 R2 或 D1 配置表（见下方说明）
EXAM_SCHEDULE      → 存 D1 配置表
CHANGELOG          → 存 D1 配置表
```

### 3.3 哪些数据不进 D1

| 数据键 | 原因 | 替代方案 |
|--------|------|----------|
| `SALARY_STORE_MAP` / `SALARY_PIN_MAP` | 激励计算器是独立应用，数据不交叉 | 保留在激励计算器本地 |
| `SALARY_HIDDEN_EMAILS` / `ADMIN_EMAIL` | 敏感配置 | 存 Cloudflare 环境变量，不回显给前端 |
| `NEWLY_ADDED` | 运行时动态维护的 ID 集合 | 建表 `new_badge_configs`，或按 `created_at` 7天内自动算 |
| 月度课时数据 | 激励计算器单独模块，不走此 API | 独立部署，不在本次范围 |

---

## 四、API 路由设计

### 4.1 公开接口（无需鉴权）

| Method | Path | 说明 |
|--------|------|------|
| `GET` | `/api/scripts` | 获取所有话术，支持 `?category=&keyword=&status=` 过滤 |
| `GET` | `/api/scripts/{id}` | 获取单条话术详情 |
| `GET` | `/api/demos` | 获取所有演示，支持 `?category=&status=` 过滤 |
| `GET` | `/api/demos/{id}` | 获取单条演示详情 |
| `GET` | `/api/notices` | 获取有效通知列表（3 天时效过滤在后端处理） |
| `GET` | `/api/favorites` | 获取当前用户收藏ID列表（按email cookie或token） |
| `POST` | `/api/favorites` | 添加收藏（body: {email, scriptId}） |
| `DELETE` | `/api/favorites/{scriptId}` | 取消收藏（body: {email, scriptId}） |
| `GET` | `/api/search-history` | 获取搜索历史（按email） |
| `POST` | `/api/search-history` | 新增搜索历史（body: {email, keyword}） |
| `DELETE` | `/api/search-history/{id}` | 删除单条搜索历史 |
| `GET` | `/api/learning/history` | 获取当前用户的学习记录（按 email cookie） |
| `POST` | `/api/learning/record` | 记录月考答题结果 |
| `GET` | `/api/config` | 获取系统配置（月度考试安排、NEWLY_ADDED 等） |

| `GET` | `/api/favorites` | 获取当前用户收藏ID列表（按email cookie或token） |
| `POST` | `/api/favorites` | 添加收藏（body: {email, scriptId}） |
| `DELETE` | `/api/favorites/{scriptId}` | 取消收藏（body: {email, scriptId}） |
| `GET` | `/api/search-history` | 获取搜索历史（按email） |
| `POST` | `/api/search-history` | 新增搜索历史（body: {email, keyword}） |
| `DELETE` | `/api/search-history/{id}` | 删除单条搜索历史 |

| Method | Path | 说明 |
|--------|------|------|
| `POST` | `/api/auth/login` | 邮箱+密码登录，返回 JWT |
| `POST` | `/api/auth/logout` | 注销（JWT 客户端失效） |
| `GET` | `/api/auth/me` | 获取当前登录管理员信息 |

### 4.3 管理员接口（需要 Bearer Token）

| Method | Path | 说明 |
|--------|------|------|
| `GET` | `/api/admin/scripts` | 管理后台话术列表 |
| `POST` | `/api/admin/scripts` | 新增话术 |
| `PUT` | `/api/admin/scripts/{id}` | 修改话术 |
| `DELETE` | `/api/admin/scripts/{id}` | 删除/归档话术 |
| `GET` | `/api/admin/demos` | 管理后台演示列表 |
| `POST` | `/api/admin/demos` | 新增演示 |
| `PUT` | `/api/admin/demos/{id}` | 修改演示 |
| `DELETE` | `/api/admin/demos/{id}` | 删除/归档演示 |
| `GET` | `/api/admin/notices` | 管理后台通知列表 |
| `POST` | `/api/admin/notices` | 发布通知 |
| `PUT` | `/api/admin/notices/{id}` | 修改通知 |
| `DELETE` | `/api/admin/notices/{id}` | 删除通知 |
| `GET` | `/api/admin/learning` | 查看学习记录汇总 |
| `POST` | `/api/admin/config` | 更新系统配置 |

### 4.4 CORS 配置

> ⚠️ **关键约束**：`Access-Control-Allow-Origin` 仅填写两个前端域名，**不把 API 子域名加入允许源列表**。

```javascript
// workers 响应头
const CORS_HEADERS = {
  "Access-Control-Allow-Origin": request.headers.get("Origin") || "",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
  "Access-Control-Allow-Credentials": "true"
};

// 白名单校验：仅放行 CloudBase 主站和 Cloudflare Pages 备用站
const ALLOWED_ORIGINS = [
  "https://zhiniao-d9goc0ztofee3fad2-1466502047.tcloudbaseapp.com",
  "https://zhiniao-workbench.pages.dev"
];

function corsHeaders(request) {
  const origin = request.headers.get("Origin");
  if (ALLOWED_ORIGINS.includes(origin)) {
    return { "Access-Control-Allow-Origin": origin, ...CORS_HEADERS };
  }
  // 预检请求（OPTIONS）直接返回，不发 Allow-Origin
  return CORS_HEADERS;
}
```

---

## 五、JWT 鉴权设计

### 5.1 Token 结构

```
Payload:
{
  "email": "maximov0607@outlook.com",
  "iat": 1724486400,
  "exp": 1725091200   // 7天后过期
}
```

### 5.2 密钥管理

- JWT 签名密钥存 **Cloudflare Workers 环境变量** `JWT_SECRET`
- 密码哈希算法：bcrypt（通过 `bcrypt.wasm` 在 Workers 运行，或使用 SHA-256 + salt 作为轻量替代）
- 首管理员密码初始化：**不实现 HTTP 形式的 `/api/admin/seed` 接口**。使用本地 `wrangler d1 execute` 命令行直接执行 SQL 写入 D1。

### 5.3 前端存储方案

- **优先使用 HttpOnly + Secure Cookie** 存放 JWT，抵御 XSS 令牌窃取；退出登录时同时清除 Cookie 与 localStorage。
- `localStorage` 仅作为兼容降级备选（旧浏览器或测试环境）。
- 每次 API 请求自动附 `Authorization: Bearer <token>` header（Cookie 模式下自动携带）。
- Token 过期跳转登录页。

---

## 六、前端改造要点

### 6.1 移除 localStorage 依赖

当前前端用到的 localStorage key：

| Key | 用途 | 替换方案 |
|-----|------|----------|
| `zn_raw_data` | 话术缓存（冗余，数据已在 HTML 中） | 删掉，直接从 API 读 RAW_DATA |
| `zn_demo_data` | 演示缓存（冗余） | 删掉 |
| `zn_favorites` | 收藏 ID 集合 | → API `/api/favorites` GET/POST/DELETE |
| `zn_search_history` | 搜索历史 | → API `/api/search-history` |
| `zn_exam_log` | 月考记录 | → API `/api/learning/record` |
| `zn_admin_state` | 管理员登录态 | → JWT token |

### 6.2 数据获取链路

```
旧链路：HTML 内嵌 JSON → localStorage 缓存 → 渲染
新链路（过渡期）：API 优先 → D1 失败时 fallback → HTML 内置兜底
新链路（最终期）：API 唯一来源 → HTML 无内置数据
```

> **过渡期重要约束**：HTML 内置 `__BUILTIN_SCRIPTS__` 仅作为只读应急降级备份；**所有新增、修改、删除话术、通知操作只写入 D1 数据库，永远不更新 HTML 内置 JSON 内容**。待系统完全稳定后，再彻底移除 HTML 内置数据。

### 6.3 API Client 封装

```javascript
// api.js — 统一 API 调用层
const API_BASE = 'https://your-workers.workers.dev';

async function request(path, options = {}) {
  const token = localStorage.getItem('zn_jwt');
  const res = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { 'Authorization': `Bearer ${token}` } : {}),
      ...options.headers,
    },
    credentials: 'include',
  });
  if (res.status === 401) {
    localStorage.removeItem('zn_jwt');
    window.location.href = '/admin/login';
  }
  return res.json();
}

export const api = {
  scripts: { list: () => request('/api/scripts'), get: id => request(`/api/scripts/${id}`) },
  demos:   { list: () => request('/api/demos'),   get: id => request(`/api/demos/${id}`) },
  notices: { list: () => request('/api/notices') },
  auth:    { login: (email, pwd) => request('/api/auth/login', { method:'POST', body:{email,password:pwd} }) },
  // ...
};
```

### 6.4 降级机制

```javascript
async function fetchScripts() {
  try {
    const data = await api.scripts.list();
    return data;
  } catch (e) {
    console.warn('[降级] API 不可用，使用内置数据兜底', e);
    return window.__BUILTIN_SCRIPTS__; // HTML 内嵌的备用数据
  }
}
```

---

## 七、分阶段交付计划

### Phase 1：核心 API + 数据库（预计 2–3 天）

**目标**：搭建 Workers + D1，跑通基础 CRUD，不影响现有网站。

**产出**：
- D1 数据库建表 + 200 条话术导入脚本
- Workers 路由表 + 公开 API（scripts/demos/notices/list）
- CORS 配置完成，双域名可访问
- 部署后可通过 curl 验证数据

**测试**：
```bash
curl https://api.yourdomain.workers.dev/api/scripts | jq '.[0]'
curl https://api.yourdomain.workers.dev/api/notices
```

### Phase 2：前端数据层切换（预计 2–3 天）

**目标**：前端从 API 读数据，降级到 HTML 兜底。

**产出**：
- `api.js` 封装
- 话术列表页、演示详情页、消息中心从 API 读数据
- localStorage 缓存逻辑移除（不删兜底）
- favorites 未定义 bug 修复（全局声明 `let favorites = new Set()`）

**测试**：
- 在 CloudBase 主站打开页面，确认话术列表正常加载
- 断网/禁用 API 后，确认降级到 HTML 内置数据仍可用
- 无痕模式打开，确认无报错

### Phase 3：鉴权 + 收藏/学习记录（预计 2 天）

**目标**：JWT 登录 + 跨设备持久化收藏和学习记录。

**产出**：
- `/api/auth/login` 端点
- JWT 签发/验证中间件
- 收藏功能对接 API（跨设备同步）
- 月考记录对接 API
- 管理员标识写入 token payload

**测试**：
- 用管理员邮箱密码登录，确认拿到 JWT
- 用普通用户邮箱登录，确认 401
- 收藏后刷新页面，确认收藏仍在
- 无痕模式登录后再收藏，确认同步到账号

### Phase 4：后台管理 + 权限系统（预计 3–4 天）

**目标**：独立 `/admin` 路由，管理员可在线编辑所有内容。

**产出**：
- `/admin` 路由（登录页 + 管理面板）
- 话术/演示/通知的增删改查 UI
- 前台话术卡片右上角出现「编辑」按钮（仅管理员可见）
- 排序拖拽功能
- CHANGELOG 管理

**测试**：
- 未登录访问 `/admin` → 跳转登录页
- 管理员登录后 → 看到编辑按钮，可修改内容
- 普通用户登录后 → 无编辑按钮
- 修改话术后 → 前台实时生效（无需重新部署）

---

## 八、风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|----------|
| Workers/D1 不可用 | 全站数据丢失 | 保留 HTML 内置数据兜底（Phase 2 起），随时可切回 |
| D1 查询性能差 | 列表加载慢 | 启用 D1 索引；对高频查询加 Workers 层内存缓存 |
| JWT 密钥泄露 | 鉴权失效 | 密钥存环境变量，不提交代码；定期轮换 |
| 免费额度超限 | Workers 限流 | 当前 6 用户量级，距离上限极远，不用担心 |
| Cloudflare Pages 与 CloudBase 域名冲突 | 部署失败 | 双域名完全独立，无冲突 |

---

## 九、开发目录规划

```
/zhiniao-backend/                          # 新建独立仓库（或同仓库子目录）
├── wrangler.toml                          # Cloudflare Workers 配置
├── src/
│   ├── index.ts                           # Workers 入口 + 路由分发
│   ├── db/
│   │   ├── schema.sql                     # D1 建表语句
│   │   └── seed.ts                        # 初始数据导入脚本
│   ├── routes/
│   │   ├── scripts.ts                     # 话术 CRUD
│   │   ├── demos.ts                       # 演示 CRUD
│   │   ├── notices.ts                     # 通知 CRUD
│   │   ├── auth.ts                        # 登录/JWT
│   │   └── admin.ts                       # 管理接口
│   └── middleware/
│       ├── cors.ts                        # CORS 中间件
│       └── auth.ts                        # JWT 验证中间件
├── init-d1.sh                             # 一键初始化数据库
└── deploy.sh                              # 一键部署脚本

/frontend/src/                             # 改造现有前端
├── api.js                                 # API 封装（新增）
├── components/
│   ├── AdminBar.js                        # 管理员操作栏（新增）
│   ├── EditableCard.js                    # 可编辑话术卡片（新增）
│   └── ...                                # 现有组件，仅替换数据源
└── admin/
    ├── login.html                         # 登录页（新增）
    └── dashboard.html                     # 管理面板（新增）
```

---

## 十、成本估算

| 服务 | 免费额度 | 预估用量 | 费用 |
|------|----------|----------|------|
| Cloudflare Workers | 10 万请求/天 | ~1,000 请求/天（6 用户） | ¥0 |
| Cloudflare D1 | 500 万读/天 + 10 万写/天 | ~5 万读/天 | ¥0 |
| Cloudflare Pages | 500 GB 带宽/月 | ~5 GB/月 | ¥0 |
| CloudBase 静态托管 | 体验版免费至 2027-02 | 不变 | ¥0 |

**总成本：¥0/月，永不收费**

---

## 十一、阶段验收核对清单

### Phase 1
- [ ] D1 建表成功（6 张表）
- [ ] 原始话术 200 条全部导入 D1
- [ ] CORS 正确放行两个域名（CloudBase 主站 + Pages 备用站）
- [ ] 无公网 `/api/admin/seed` 初始化接口
- [ ] 通过 curl 验证 `GET /api/scripts` 返回数据

### Phase 2
- [ ] 前端优先调用 API
- [ ] 网络异常可降级读取 HTML 内置数据
- [ ] 修改话术仅写 D1，HTML 兜底数据只读不修改
- [ ] 修复 favorites 未定义，无痕模式打开无 JS 报错

### Phase 3
- [ ] 管理员登录 JWT 正常
- [ ] 优先 HttpOnly Cookie 存储 token
- [ ] 收藏、搜索历史、月考记录云端同步
- [ ] 更换设备数据保留

### Phase 4
- [ ] 访问 `/admin` 未登录自动跳转登录页
- [ ] 管理员登录后前台展示编辑按钮，普通访客不可见
- [ ] 后台编辑保存，前台实时生效，无需重新部署

## 十二、D1 初始化命令（本地执行）

> 不使用 HTTP seed 接口。管理员在本地终端执行以下命令完成首管理员初始化。

```bash
# 1. 创建 D1 数据库（如尚未创建）
wrangler d1 create zhiniao-db

# 2. 执行建表 SQL
wrangler d1 execute zhiniao-db --file src/db/schema.sql

# 3. 导入初始数据（话术/演示/通知）
wrangler d1 execute zhiniao-db --command ".read src/db/seed.sql"

# 4. 生成密码哈希（nodejs 本地生成 bcrypt hash）
# 在 src/db/ 目录下创建 seed-admin.cjs：
# const bcrypt = require('bcrypt');
# bcrypt.hash('你的临时密码', 10).then(hash => console.log(hash));
# node src/db/seed-admin.cjs > password_hash.txt

# 5. 插入首管理员（maximov0607@outlook.com）
wrangler d1 execute zhiniao-db --command "
INSERT INTO admins (email, password_hash, created_at)
VALUES ('maximov0607@outlook.com', '<从password_hash.txt复制>', datetime('now'));
"

# 6. 验证
wrangler d1 execute zhiniao-db --command "SELECT * FROM admins;"
wrangler d1 execute zhiniao-db --command "SELECT COUNT(*) FROM scripts;"
```
