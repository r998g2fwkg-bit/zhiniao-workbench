-- 知鸟答案工作台 D1 数据库建表语句
-- 环境：Cloudflare D1 (SQLite)
-- 更新日期：2026-08-24

-- 话术表（对应 RAW_DATA）
CREATE TABLE IF NOT EXISTS scripts (
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
  status      TEXT NOT NULL DEFAULT 'active'
);

-- 演示表（对应 DEMO_DATA）
CREATE TABLE IF NOT EXISTS demos (
  id          TEXT PRIMARY KEY,
  sheet       TEXT,
  topic       TEXT,
  status      TEXT DEFAULT 'active',
  category    TEXT,
  demo_type   TEXT,
  intro       TEXT,
  demo_images TEXT
);

-- 通知表（对应 NOTICES）
CREATE TABLE IF NOT EXISTS notices (
  id        TEXT PRIMARY KEY,
  level     TEXT NOT NULL,
  date      TEXT NOT NULL,
  sticky    INTEGER NOT NULL DEFAULT 0,
  title     TEXT NOT NULL,
  body      TEXT,
  image     TEXT
);

-- 学习记录表（新模块，跨设备持久化）
CREATE TABLE IF NOT EXISTS learning_records (
  id          TEXT PRIMARY KEY,
  email       TEXT NOT NULL,
  kind        TEXT NOT NULL,
  exam_date   TEXT NOT NULL,
  score       INTEGER,
  total       INTEGER,
  answers     TEXT,
  created_at  TEXT NOT NULL
);

-- ⚠️ 普通用户风险备注：当前版本无普通用户注册登录体系，
-- 用户身份由前端提交 email 标识，仅适合小范围内部使用。

-- 月考命中记录表
CREATE TABLE IF NOT EXISTS exam_hits (
  id          TEXT PRIMARY KEY,
  email       TEXT NOT NULL,
  exam_id     TEXT NOT NULL,
  script_id   TEXT NOT NULL,
  is_correct  INTEGER NOT NULL,
  recorded_at TEXT NOT NULL
);

-- 管理员表
CREATE TABLE IF NOT EXISTS admins (
  email         TEXT PRIMARY KEY,
  password_hash TEXT NOT NULL,
  created_at    TEXT NOT NULL
);

-- 收藏表
CREATE TABLE IF NOT EXISTS favorites (
  id        TEXT PRIMARY KEY,
  email     TEXT NOT NULL,
  script_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  UNIQUE(email, script_id)
);

-- 搜索历史表
CREATE TABLE IF NOT EXISTS search_history (
  id        TEXT PRIMARY KEY,
  email     TEXT NOT NULL,
  keyword   TEXT NOT NULL,
  created_at TEXT NOT NULL
);

-- 系统配置表
CREATE TABLE IF NOT EXISTS config (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- 索引
CREATE INDEX idx_scripts_category ON scripts(category);
CREATE INDEX idx_scripts_status ON scripts(status);
CREATE INDEX idx_scripts_sheet ON scripts(sheet);
CREATE INDEX idx_learning_email ON learning_records(email);
CREATE INDEX idx_favorites_email ON favorites(email);
CREATE INDEX idx_exam_hits_email ON exam_hits(email);
