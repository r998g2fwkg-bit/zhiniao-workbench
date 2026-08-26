#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
知鸟答案工作台 · 构建脚本 (build.py)
把数据真源 data/app_data.json 烘焙进模板 src/知鸟答案工作台.template.html，
生成三端完全一致的可部署 HTML（源文件 + dist/index.html + dist/index.static.html）。

=== 3C 数据抽离后的标准工作流 ===
1. 改数据：直接用 Python/编辑器修改 data/app_data.json（标准 JSON，格式错立即报错，绝不会拖垮页面逻辑）。
2. 重新构建：python3 build.py   （校验后会写出三端产物）
3. 部署：CloudBase 静态托管重新部署 dist/（链接不变：*.tcloudbaseapp.com）
4. 核验：python3 release_check.py

随构建一并同步到 dist 的子资源：
- coach-salary-online/  （薪资/激励计算器独立目录）
- 课时追踪.html          （课时追踪独立单文件，源在 2026-07-07-16-22-15/）

设计要点：
- 部署产物仍是「单文件、零运行时 fetch、零后端」——JSON 在构建期内联进 <script>，运行时行为与抽离前完全一致。
- 注入时对 JSON 中的 </ 做转义（</script> 防御），避免数据文本提前闭合脚本标签。
"""
import json, os, sys, shutil

ROOT = '/Users/zhoujiale/WorkBuddy/2026-08-04-16-18-01'
DATA = os.path.join(ROOT, 'data', 'app_data.json')
TPL = os.path.join(ROOT, 'src', '知鸟答案工作台.template.html')
OUTS = [
    os.path.join(ROOT, '知鸟答案工作台.html'),
    os.path.join(ROOT, 'dist', 'index.html'),
    os.path.join(ROOT, 'dist', 'index.static.html'),
]
PLACEHOLDER = '__APP_DATA_JSON__'

def fail(msg):
    print(f"  [FAIL] {msg}")
    sys.exit(1)

def main():
    # 1) 读取并校验数据真源
    try:
        with open(DATA, 'r', encoding='utf-8') as f:
            app_data = json.load(f)
    except Exception as e:
        fail(f"app_data.json 解析失败（数据文件格式错误，请在修改时修正）: {e}")

    raw_count = len(app_data.get('RAW_DATA', []))
    print(f"  [数据] app_data.json 解析 OK，RAW_DATA={raw_count} 项，共 {len(app_data)} 个键")

    # 2) 读取模板
    try:
        with open(TPL, 'r', encoding='utf-8') as f:
            tpl = f.read()
    except Exception as e:
        fail(f"模板读取失败: {e}")

    if PLACEHOLDER not in tpl:
        fail(f"模板中未找到注入占位符 {PLACEHOLDER}")

    # 3) 生成注入内容（紧凑 JSON，中文直出，转义 </）
    blob = json.dumps(app_data, ensure_ascii=False)
    blob = blob.replace('</', '<\\/')  # 防御 </script> 提前闭合
    built = tpl.replace(PLACEHOLDER, blob)

    if PLACEHOLDER in built:
        fail(f"构建后仍存在残留占位符 {PLACEHOLDER}")

    # 4) 写出三端
    for out in OUTS:
        os.makedirs(os.path.dirname(out), exist_ok=True)
        with open(out, 'w', encoding='utf-8') as f:
            f.write(built)
        print(f"  [写出] {os.path.relpath(out, ROOT)}  ({os.path.getsize(out)} bytes)")

    # 5) 三端一致性 + 数据 blob 可再解析校验
    texts = {}
    for out in OUTS:
        with open(out, 'r', encoding='utf-8') as f:
            texts[out] = f.read()
    # 三端字节一致
    sizes = {os.path.getsize(o) for o in OUTS}
    if len(sizes) != 1:
        fail(f"三端文件大小不一致: {sizes}")
    # 抽取运行时数据 blob 并确认可解析
    import re
    m = re.search(r'window\.__APP_DATA__\s*=\s*(.*?);\s*</script>', texts[OUTS[0]], re.S)
    if not m:
        fail("未能在产物中定位 window.__APP_DATA__ 数据 blob")
    try:
        reparsed = json.loads(m.group(1).replace('<\\/', '</'))
    except Exception as e:
        fail(f"产物内数据 blob 无法解析: {e}")
    if len(reparsed.get('RAW_DATA', [])) != raw_count:
        fail(f"产物内 RAW_DATA 计数({len(reparsed['RAW_DATA'])})与源({raw_count})不符")
    # 三端 blob 文本一致
    blobs = {re.search(r'window\.__APP_DATA__\s*=\s*(.*?);\s*</script>', texts[o], re.S).group(1) for o in OUTS}
    if len(blobs) != 1:
        fail("三端数据 blob 不一致")

    # 6) 同步薪资计算器(激励计算器) 到 dist（独立静态子目录，随工作台一并部署到 CloudBase）
    src_salary = os.path.join(ROOT, 'coach-salary-online')
    dst_salary = os.path.join(ROOT, 'dist', 'coach-salary-online')
    if os.path.isdir(src_salary):
        if os.path.isdir(dst_salary):
            shutil.rmtree(dst_salary)
        shutil.copytree(src_salary, dst_salary)
        print(f"  [复制] coach-salary-online/ → dist/coach-salary-online/")
    else:
        print(f"  [跳过] 未找到 coach-salary-online/ 源目录，跳过薪资计算器同步")

    # 7) 同步课时追踪(独立单文件，不在工作台模板内) 到 dist（随工作台一并部署到 CloudBase）
    kt_src = '/Users/zhoujiale/WorkBuddy/2026-07-07-16-22-15/课时追踪.html'
    kt_dst = os.path.join(ROOT, 'dist', '课时追踪.html')
    if os.path.isfile(kt_src):
        shutil.copy2(kt_src, kt_dst)
        print(f"  [复制] 课时追踪.html → dist/课时追踪.html  ({os.path.getsize(kt_dst)} bytes)")
    else:
        print(f"  [跳过] 未找到课时追踪.html 源文件，跳过同步")

    print(f"\n✅ 构建完成：三端一致，RAW_DATA={raw_count} 项，数据 blob 校验通过，无残留占位符。")
    print(f"   已同步子资源 → dist/coach-salary-online/、dist/课时追踪.html")

if __name__ == '__main__':
    main()
