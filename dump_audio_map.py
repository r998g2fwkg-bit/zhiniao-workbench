"""生成单个音频文件的角色时间轴 JSON（audio_map.json）"""
import json, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from align_engine import match_rows, analyze_file

ITEMS = json.load(open("zhiniao_data.json", encoding="utf-8"))

def build_map(mp3_rel, items):
    base = os.path.basename(mp3_rel)
    fp = mp3_rel
    group = match_rows(base, items)
    if not group:
        print("未匹配到话术组:", base); return None
    topic = group[0]["topic"]  # 含换行，需与 HTML 分组 key 一致
    turns, expected, segs = analyze_file(fp, group)
    # 合并：匹配段 type=qa，未匹配段 type=extra（按检测性别标注角色）
    segments = []
    order = 0
    for (s, e, g) in turns:
        order += 1
        if order - 1 < len(segs) and segs[order - 1]["rowId"]:
            sg = segs[order - 1]
            segments.append({"start": s, "end": e, "role": sg["role"],
                             "rowId": sg["rowId"], "text": sg["text"], "type": "qa"})
        else:
            role = "female" if g == "F" else "male"
            segments.append({"start": s, "end": e, "role": role, "rowId": "",
                             "text": "", "type": "extra"})
    return {topic: {"file": base, "segments": segments}}

if __name__ == "__main__":
    mp3 = "/Users/zhoujiale/Library/Mobile Documents/com~apple~CloudDocs/知鸟话术音频/Mac/MacBook Neo常见问题 (202603).mp3"
    m = build_map(mp3, ITEMS)
    print("topic key:", repr(list(m.keys())[0]))
    segs = list(m.values())[0]["segments"]
    qa = [s for s in segs if s["type"] == "qa"]
    extra = [s for s in segs if s["type"] == "extra"]
    print(f"总段数: {len(segs)} | 已匹配(挂话术): {len(qa)} | 附加片段: {len(extra)}")
    print("\n已匹配段:")
    for s in qa:
        ic = "👩" if s["role"] == "female" else "👨"
        print(f"  {ic} {s['start']:6.1f}-{s['end']:6.1f}s [{s['rowId']}] {s['text'][:28]}")
    print(f"\n附加片段: {len(extra)} 段（按检测性别标注，无对应文字）")
    json.dump(m, open("audio_map.json", "w", encoding="utf-8"), ensure_ascii=False, indent=2)
    print("\n已保存 audio_map.json")
