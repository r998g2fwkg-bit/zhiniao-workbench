#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
知鸟答案工作台 · 待补清单跨店汇总 (merge_gaps.py)
把各门店导出的 待补清单_<门店>_<月份>.json 合并，产出：
  1) 高频盲区清单（同一未匹配题被越多门店报出 → 越该优先补）
  2) 高频命中条目（被考最多的内容，用于判断题库热度）
  3) 盲区汇总.json（gaps_ranked / hits_top，供 AI 烘焙参考）
用法: python3 merge_gaps.py [目录，默认 ./gaps_in]
"""
import json, glob, os, re, sys, collections

# 与前端 examNorm 对齐的归一化（用于跨店去重同一道题）
def exam_norm(s):
    if s is None: s = ''
    s = str(s)
    # 全角 ASCII (U+FF01–U+FF5E) → 半角
    s = ''.join(chr(ord(ch) - 0xFEE0) if 0xFF01 <= ord(ch) <= 0xFF5E else ch for ch in s)
    s = s.replace('　', ' ')           # 表意空格
    s = re.sub(r'\s+', '', s)
    s = re.sub(r'[（(]\s*\d{3,8}\s*[)）]', '', s)
    punct = r'[「」【】《》〈〉“”‘’、，。！？：；·．…～~\-–—_/\\|\[\]{}()（）"\',.!?:;]'
    s = re.sub(punct, '', s)
    return s.lower()

def main():
    d = sys.argv[1] if len(sys.argv) > 1 else './gaps_in'
    files = sorted(glob.glob(os.path.join(d, '待补清单_*.json')))
    if not files:
        print(f"未找到 待补清单_*.json 文件于: {d}")
        sys.exit(1)

    stores, months = set(), set()
    gap_records, hit_records = [], []
    for fp in files:
        with open(fp, encoding='utf-8') as f:
            data = json.load(f)
        store = data.get('store', '?'); month = data.get('month', '?')
        stores.add(store); months.add(month)
        for g in data.get('gaps', []):
            q = g.get('q', '')
            gap_records.append((exam_norm(q), store, q))
        for h in data.get('hits', []):
            hit_records.append((h.get('sheet', ''), h.get('topic', ''), h.get('itemId', ''), store, h.get('q', '')))

    # ---- 盲区聚合（按归一化题面去重）----
    agg = collections.defaultdict(lambda: {'stores': set(), 'count': 0, 'samples': []})
    for k, store, raw in gap_records:
        if not k:
            continue
        agg[k]['stores'].add(store); agg[k]['count'] += 1
        if len(agg[k]['samples']) < 3:
            agg[k]['samples'].append(raw)
    ranked = sorted(agg.items(), key=lambda kv: (-len(kv[1]['stores']), -kv[1]['count']))

    # ---- 命中聚合（按 sheet+topic+itemId 去重）----
    happ = collections.defaultdict(lambda: {'stores': set(), 'count': 0, 'sample': ''})
    for sheet, topic, itemId, store, raw in hit_records:
        key = (sheet, topic, itemId)
        happ[key]['stores'].add(store); happ[key]['count'] += 1
        if not happ[key]['sample']:
            happ[key]['sample'] = raw
    hr = sorted(happ.items(), key=lambda kv: (-kv[1]['count'], -len(kv[1]['stores'])))

    print(f"汇总门店数: {len(stores)}  月份: {sorted(months)}")
    print(f"原始盲区记录: {len(gap_records)} 条 → 去重后 {len(agg)} 题")
    print("\n=== 高频盲区（按报出门店数降序；越多门店独立报出，越该优先补）===")
    for k, v in ranked:
        print(f"  [{len(v['stores'])}店/{v['count']}次] {v['samples'][0][:60]}")

    print(f"\n=== 高频命中条目（被考最多的内容，共 {len(happ)} 条去重）Top20 ===")
    for (sheet, topic, itemId), v in hr[:20]:
        print(f"  [{v['count']}次/{len(v['stores'])}店] {sheet} / {topic} / {itemId}")

    out = {
        'months': sorted(months),
        'stores': sorted(stores),
        'gaps_ranked': [
            {'q': v['samples'][0], 'stores': sorted(v['stores']),
             'storeCount': len(v['stores']), 'count': v['count']}
            for k, v in ranked
        ],
        'hits_top': [
            {'sheet': k[0], 'topic': k[1], 'itemId': k[2],
             'stores': sorted(v['stores']), 'count': v['count']}
            for k, v in hr
        ],
    }
    with open(os.path.join(d, '盲区汇总.json'), 'w', encoding='utf-8') as f:
        json.dump(out, f, ensure_ascii=False, indent=2)
    print(f"\n已写出: {os.path.join(d, '盲区汇总.json')} （gaps_ranked / hits_top，供烘焙参考）")

if __name__ == '__main__':
    main()
