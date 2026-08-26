-- 知鸟答案工作台 D1 数据导入脚本
-- 自动生成于 2026-08-24
-- 来源：data/app_data.json

-- ====================
-- 导入通知 (NOTICES)
-- ====================
INSERT OR IGNORE INTO notices (id, level, date, sticky, title, body, image) VALUES ('n20260811-453', 'important', '2026-08-11', 0, '两个功能更新', '1）原「Coach 薪资计算器」已更名为「激励计算器」，整合进 Ai Coach & Demo 工作台（左侧菜单可进）。因薪资保密，每位仅可看所属门店的激励数据，PIN 码默认为手机号后四位。

2）月考模式新增「BUG 提交指引」：考试遇卡顿 BUG 时，在粘贴题目清单区域下方展开该指引。

有问题随时群里喊我～', NULL);
INSERT OR IGNORE INTO notices (id, level, date, sticky, title, body, image) VALUES ('n20260813-834', 'normal', '2026-08-13', 0, 'AiDemo 图片校对', '😁家人们，现在已经对所有演示话术的图片都校对完成，可以朗读话术的同时对照演示图完成测试。', NULL);
INSERT OR IGNORE INTO notices (id, level, date, sticky, title, body, image) VALUES ('n20260820-712', 'important', '2026-08-20', 1, '「课时追踪」重新上线', '课时追踪功能已完成课程合并与界面优化，现重新在工作台顶部标签开放。

使用方式：进入 MyCoach → Coach Workstation → 拷贝当天所有服务记录，粘贴到「课时追踪」录入区；休息单独标记。

当前为 8 月数据，请按实际排班与剩余上班日调整目标规划。', 'assets/notices/notice-hours-tracker-v2.jpg');

-- ====================
-- 导入系统配置
-- ====================
INSERT OR REPLACE INTO config (key, value) VALUES ('newly_added', '["0195", "0196", "0197", "0164", "0165"]');
INSERT OR REPLACE INTO config (key, value) VALUES ('exam_schedule', '[{"name": "AiCoach · 话术考核", "dateText": "8月21日", "kind": "coach"}, {"name": "AiDemo · 演示考核", "dateText": "8月27日", "kind": "demo"}]');
INSERT OR REPLACE INTO config (key, value) VALUES ('aep_weekly', '[{"weekId": "Q4W8", "dateRange": "8月16日–8月22日", "startDate": "2026-08-16", "pdfName": "AEP学习内容 Q4W8（iPad加强周）", "pdfPath": "assets/weekly/2026-Q4W8-aep.pdf", "pngPath": "assets/weekly/2026-Q4W8-aep.png", "scripts": [{"title": "推荐“eSIM iPad 乐享 5G” 超值优惠活动（202412）", "matchId": "0072", "sheet": "iPad销售话术系列", "matched": true}, {"title": "iPad mini 小巧又强大（202410）", "matchId": "0076", "sheet": "iPad销售话术系列", "matched": true}, {"title": "A16 芯片 iPad，多彩又强大（202503）", "matchId": "0077", "sheet": "iPad销售话术系列", "matched": true}, {"title": "向顾客介绍 iPadOS 26（202507）", "matchId": "0078", "sheet": "iPad销售话术系列", "matched": true}], "demos": [{"title": "iPad 如何激活 eSIM 服务", "matchId": "demo20", "sheet": "iPad演示系列", "matched": true}, {"title": "iPad提升效率好帮手（2512）", "matchId": "demo21", "sheet": "iPad演示系列", "matched": true}, {"title": "iPad Pro 性能出类拔萃（2512）", "matchId": "demo22", "sheet": "iPad演示系列", "matched": true}, {"title": "iPadOS 科学计算器（2512）", "matchId": "demo23", "sheet": "iPad演示系列", "matched": true}]}, {"weekId": "Q4W9", "dateRange": "8月23日–8月29日", "startDate": "2026-08-23", "pdfName": "AEP学习内容 Q4W9（Watch加强周）", "pdfPath": "assets/weekly/2026-Q4W9-aep.pdf", "pngPath": "assets/weekly/2026-Q4W9-aep.png", "scripts": [{"title": "满手高招的 Apple Watch Series 11 (202309)", "matchId": "0121", "sheet": "Watch销售话术系列", "matched": true}, {"title": "无限你的野 Apple Watch Ultra3 (202509)", "matchId": "0122", "sheet": "Watch销售话术系列", "matched": true}, {"title": "你的超值之选 Apple Watch SE3 (202509)", "matchId": "0124", "sheet": "Watch销售话术系列", "matched": true}, {"title": "向顾客介绍 iCloud 自动备份和云盘（202608）", "matchId": "0195", "sheet": "配件和服务销售话术系列", "matched": true}], "demos": [{"title": "Apple Watch 助你好睡眠（2509）", "matchId": "demo12", "sheet": "Apple Watch演示系列", "matched": true}, {"title": "Apple Watch 体能训练（202510）", "matchId": "demo13", "sheet": "Apple Watch演示系列", "matched": true}, {"title": "Apple Watch 日常生活更轻松（202510）", "matchId": "demo14", "sheet": "Apple Watch演示系列", "matched": true}, {"title": "Apple Watch 心率血氧（202512）", "matchId": "demo15", "sheet": "Apple Watch演示系列", "matched": true}]}]');
INSERT OR REPLACE INTO config (key, value) VALUES ('changelog', '[{"date": "2026-08-23", "type": "优化", "desc": "AEP 周任务详情页左右箭头导航限定在当前周匹配序列，不再跳转全局列表"}, {"date": "2026-08-23", "type": "优化", "desc": "Lightbox 大图预览新增朗读按钮，朗读演示正文内容（非标题）"}, {"date": "2026-08-22", "type": "优化", "desc": "Tab 角标系统上线——数字计数 + 48h 时效自动消失 + 进入清零 + AEP 周任务门控（未开启周不出角标）"}, {"date": "2026-08-22", "type": "优化", "desc": "月考安排信息融合进「考试类型」胶囊，显示考试日期，替代独立卡片"}, {"date": "2026-08-18", "type": "优化", "desc": "站内通知与更新日志合并为单一「消息中心」，铃铛为唯一入口，支持双标签切换"}, {"date": "2026-08-18", "type": "优化", "desc": "通知 3 天时效自动转历史（置顶除外）"}, {"date": "2026-08-18", "type": "调整", "desc": "课时追踪版块暂时下线（代码保留，后续恢复）"}, {"date": "2026-08-18", "type": "优化", "desc": "通知与更新日志合并为消息中心；通知超 3 天自动转历史（置顶除外）"}, {"date": "2026-08-17", "type": "增强", "desc": "月考命中：置信度徽章 + 标题命中高亮 + 近似候选"}, {"date": "2026-08-17", "type": "优化", "desc": "待补清单支持跨店汇总导出(.json)与合并烘焙"}, {"date": "2026-08-17", "type": "改名", "desc": "测试账户改名为「Onezero长沙河西王府井店」"}, {"date": "2026-08-16", "type": "修正", "desc": "AEP 周任务起止改为周日至周六"}, {"date": "2026-08-16", "type": "新增", "desc": "头像点击强制刷新；新增测试账户头像"}]');
