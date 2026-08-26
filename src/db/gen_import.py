#!/usr/bin/env python3
"""将 app_data.json 转换为 D1 SQL 导入脚本"""
import json
import os

DATA_FILE = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/data/app_data.json'
OUTPUT_DIR = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01/src/db'

def sql_escape(s):
    """转义 SQL 单引号"""
    return s.replace("'", "''").replace("\\", "\\\\")

def main():
    with open(DATA_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)

    lines = []
    lines.append("-- 知鸟答案工作台 D1 数据导入脚本")
    lines.append("-- 自动生成于 2026-08-24")
    lines.append("-- 来源：data/app_data.json")
    lines.append("")

    # 导入 NOTICES
    lines.append("-- ====================")
    lines.append("-- 导入通知 (NOTICES)")
    lines.append("-- ====================")
    for n in data.get('NOTICES', []):
        nid = sql_escape(n['id'])
        level = sql_escape(n.get('level', 'info'))
        date = sql_escape(n.get('date', ''))
        sticky = 1 if n.get('sticky') else 0
        title = sql_escape(n.get('title', ''))
        body = sql_escape(n.get('body', ''))
        image = sql_escape(n.get('image', '')) if n.get('image') else ''
        img_val = f"'{image}'" if image else "NULL"
        lines.append(f"INSERT OR IGNORE INTO notices (id, level, date, sticky, title, body, image) VALUES ('{nid}', '{level}', '{date}', {sticky}, '{title}', '{body}', {img_val});")
    lines.append("")

    # 导入配置项
    lines.append("-- ====================")
    lines.append("-- 导入系统配置")
    lines.append("-- ====================")

    # NEWLY_ADDED
    newly = data.get('NEWLY_ADDED', [])
    if newly:
        newly_json = json.dumps(newly, ensure_ascii=False)
        lines.append(f"INSERT OR REPLACE INTO config (key, value) VALUES ('newly_added', '{sql_escape(newly_json)}');")

    # EXAM_SCHEDULE
    exams = data.get('EXAM_SCHEDULE', [])
    if exams:
        exams_json = json.dumps(exams, ensure_ascii=False)
        lines.append(f"INSERT OR REPLACE INTO config (key, value) VALUES ('exam_schedule', '{sql_escape(exams_json)}');")

    # AEP_WEEKLY
    aep = data.get('AEP_WEEKLY', [])
    if aep:
        aep_json = json.dumps(aep, ensure_ascii=False)
        lines.append(f"INSERT OR REPLACE INTO config (key, value) VALUES ('aep_weekly', '{sql_escape(aep_json)}');")

    # CHANGELOG
    cl = data.get('CHANGELOG', [])
    if cl:
        cl_json = json.dumps(cl, ensure_ascii=False)
        lines.append(f"INSERT OR REPLACE INTO config (key, value) VALUES ('changelog', '{sql_escape(cl_json)}');")
    lines.append("")

    # 导出到文件
    with open(os.path.join(OUTPUT_DIR, 'seed.sql'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print(f"✅ seed.sql 已生成 ({len(lines)} 行)")

    # 生成批量导入脚本
    script_lines = []
    script_lines.append("-- 批量导入话术和演示数据")
    script_lines.append("")

    # RAW_DATA -> scripts
    script_lines.append("-- ====================")
    script_lines.append("-- 导入话术 (RAW_DATA)")
    script_lines.append("-- ====================")
    count = 0
    for item in data.get('RAW_DATA', []):
        sid = sql_escape(item['id'])
        sheet = sql_escape(item.get('sheet', ''))
        cat = sql_escape(item.get('category', ''))
        topic = sql_escape(item.get('topic', '')).replace('\\n', '\\n')
        turn = item.get('turn', 1)
        follow_up = 1 if item.get('isFollowUp') else 0
        question = sql_escape(item.get('question', '')).replace('\\n', '\\n')
        answer = sql_escape(item.get('answer', '')).replace('\\n', '\\n')
        keywords = sql_escape(item.get('keywords', ''))
        created_at = sql_escape(item.get('createdAt', '2020-01-01'))
        status = sql_escape(item.get('status', 'active'))
        script_lines.append(f"INSERT OR IGNORE INTO scripts (id, sheet, category, topic, turn, is_follow_up, question, answer, keywords, created_at, status) VALUES ('{sid}', '{sheet}', '{cat}', '{topic}', {turn}, {follow_up}, '{question}', '{answer}', '{keywords}', '{created_at}', '{status}');")
        count += 1
    script_lines.append("")

    # DEMO_DATA -> demos
    script_lines.append("-- ====================")
    script_lines.append("-- 导入演示 (DEMO_DATA)")
    script_lines.append("-- ====================")
    demo_count = 0
    for item in data.get('DEMO_DATA', []):
        did = sql_escape(item['id'])
        sheet = sql_escape(item.get('sheet', ''))
        topic = sql_escape(item.get('topic', '')).replace('\\n', '\\n')
        status = sql_escape(item.get('status', 'active'))
        cat = sql_escape(item.get('category', ''))
        demo_type = sql_escape(item.get('demoType', ''))
        intro = sql_escape(item.get('intro', '')).replace('\\n', '\\n')
        images = item.get('demoImages', [])
        images_json = json.dumps(images, ensure_ascii=False)
        script_lines.append(f"INSERT OR IGNORE INTO demos (id, sheet, topic, status, category, demo_type, intro, demo_images) VALUES ('{did}', '{sheet}', '{topic}', '{status}', '{cat}', '{demo_type}', '{intro}', '{images_json}');")
        demo_count += 1
    script_lines.append("")

    with open(os.path.join(OUTPUT_DIR, 'import_data.sql'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(script_lines))
    print(f"✅ import_data.sql 已生成（{count} 条话术 + {demo_count} 条演示）")

if __name__ == '__main__':
    main()
