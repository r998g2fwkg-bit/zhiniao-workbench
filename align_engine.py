"""知鸟话术音频对齐引擎
流程：
  1. 声学切边界：把 mp3 转 16k 单声道 wav，按能量/静音切出『语音段』(turn)
  2. 结构派角色：根据每行 B/C 列 + 是否以『场景』开头，生成期望的 (角色, 文字, rowId) 序列
  3. 顺序对齐：把语音段按序映射到角色序列（不强行交替，允许连续同角色）
角色只靠结构规则定（不靠音高猜），音高仅用于边界检测与校验。
"""
import json, re, subprocess, wave, os
import numpy as np
import imageio_ffmpeg

FF = imageio_ffmpeg.get_ffmpeg_exe()

def to_wav(mp3_path, wav_path):
    subprocess.run([FF, "-y", "-i", mp3_path, "-ar", "16000", "-ac", "1", "-f", "wav", wav_path],
                   capture_output=True)
    return wav_path

def detect_turns(wav_path, min_turn=0.4, merge_gap=1.5, gender_th=None, silence=0.8):
    """基频分层切分：返回 [(start, end, gender), ...]  gender in {'F','M'}"""
    w = wave.open(wav_path)
    fr = w.getframerate(); n = w.getnframes()
    data = np.frombuffer(w.readframes(n), dtype=np.int16).astype(np.float32)
    if data.size == 0:
        return []
    data = np.append(data[0], data[1:] - 0.97 * data[:-1])  # 预加重
    hop = 256; win = 1024
    minlag = int(0.002 * fr); maxlag = int(0.013 * fr)
    times = []; f0 = []; rms = []
    peak = 0
    for i in range(0, len(data) - win, hop):
        seg = data[i:i + win]; seg = seg - seg.mean()
        r = np.sqrt(np.mean(seg ** 2)); peak = max(peak, r)
        corr = np.correlate(seg, seg, 'full')[len(seg) - 1:]
        c2 = corr.copy(); c2[:minlag] = 0; c2[maxlag + 1:] = 0
        lag = np.argmax(c2) + 1
        if r > peak * 0.03 and c2[lag - 1] > 0.3 * np.max(c2) and maxlag >= lag - 1 >= minlag:
            f0.append(fr / lag)
        else:
            f0.append(0.0)
        rms.append(r); times.append(i / fr)
    f0 = np.array(f0); rms = np.array(rms); times = np.array(times)
    valid = f0[f0 > 0]
    if gender_th is None and len(valid):
        gender_th = float(np.median(valid))
    gender = np.where(f0 >= gender_th, 1, 0)
    voiced = f0 > 0
    def medfilt(x, k=9):
        return np.array([np.median(x[max(0, i - k):i + k + 1]) for i in range(len(x))])
    gnum = medfilt(gender.astype(float), 9)
    gsmooth = np.where(gnum >= 0.5, 'F', 'M')
    si = 0; L = len(times); turns = []
    while si < L:
        if not voiced[si]:
            si += 1; continue
        g = gsmooth[si]; sj = si
        while sj < L:
            end_cond = (sj + 1 < L and (not voiced[sj + 1] and (times[sj + 1] - times[sj]) > silence))
            change = (sj + 1 < L and voiced[sj + 1] and gsmooth[sj + 1] != g)
            if end_cond or change:
                break
            sj += 1
        s, e = times[si], times[min(sj, L - 1)]
        if e - s >= min_turn:
            turns.append([round(float(s), 2), round(float(e), 2), g])
        si = sj + 1
    merged = []
    for t in turns:
        if merged and t[2] == merged[-1][2] and t[0] - merged[-1][1] < merge_gap:
            merged[-1][1] = t[1]
        else:
            merged.append(list(t))
    return [tuple(x) for x in merged]

SCENE_RE = re.compile(r'^场景[：:\s1-9]*')

def row_speakers(row):
    """返回 [(role, text, rowId), ...]  role in {'male','female'}"""
    b = (row.get("question") or "").strip()
    c = (row.get("answer") or "").strip()
    rid = row["id"]
    out = []
    if SCENE_RE.match(b):
        parts = b.split("\n", 1)
        scenario = parts[0].replace("场景", "", 1).strip("：: ")
        rest = parts[1].strip() if len(parts) > 1 else ""
        if scenario:
            out.append(("male", scenario, rid))          # 店员先开口：场景开场白
        if rest:
            out.append(("female", rest, rid))             # 顾客问题
        elif not c:
            pass
        if c:
            out.append(("male", c, rid))                  # 店员回答
    else:
        if b:
            out.append(("female", b, rid))
        if c:
            out.append(("male", c, rid))
    return out

def build_expected(rows):
    """整组话术的期望角色序列"""
    seq = []
    for r in rows:
        for role, text, rid in row_speakers(r):
            seq.append({"role": role, "text": text, "rowId": rid})
    return seq

def align(turns, expected):
    """把语音段(含gender)按序映射到期望角色；返回 segments=[{start,end,role,dgender,rowId,text}]"""
    segs = []
    ei = 0
    for (s, e, g) in turns:
        if ei < len(expected):
            ex = expected[ei]
            segs.append({"start": s, "end": e, "role": ex["role"], "dgender": g,
                         "rowId": ex["rowId"], "text": ex["text"]})
            ei += 1
        else:
            segs.append({"start": s, "end": e, "role": "unknown", "dgender": g, "rowId": "", "text": ""})
    return segs

def analyze_file(mp3_path, rows):
    wav = "/tmp/_align.wav"
    to_wav(mp3_path, wav)
    turns = detect_turns(wav)
    expected = build_expected(rows)
    segs = align(turns, expected)
    return turns, expected, segs

def norm(s):
    return re.sub(r'\s+', '', str(s)).lower()

def match_rows(filename, items):
    """根据音频文件名找到对应的话术行组（同 sheet 下 topic 命中）"""
    base = re.sub(r'\s*\(?\d{6}\)?\s*\.mp3$', '', filename, flags=re.I)
    base_n = norm(base)
    # 推断品类（文件夹名）→ sheet
    sheet_hint = None
    for s in set(x["sheet"] for x in items):
        if norm(s)[:4] in base_n or base_n[:4] in norm(s):
            sheet_hint = s; break
    cand = [x for x in items if (sheet_hint is None or x["sheet"] == sheet_hint)]
    # 用文件名核心词匹配 topic
    core = re.sub(r'（\d+）|\((\d+)\)', '', base).strip()
    core_n = norm(core)
    matched = [x for x in cand if core_n and core_n in norm(x["topic"])]
    if not matched:
        # 退而求其次：token 重叠
        toks = set(re.findall(r'[a-z0-9一-龥]{2,}', core_n))
        scored = []
        for x in cand:
            t = set(re.findall(r'[a-z0-9一-龥]{2,}', norm(x["topic"])))
            ov = len(toks & t)
            if ov:
                scored.append((ov, x))
        scored.sort(key=lambda z: -z[0])
        matched = [x for _, x in scored[:6]] if scored else []
    # 归入同一 topic 组（按 topic 聚合，取最长组）
    if matched:
        groups = {}
        for x in matched:
            groups.setdefault(x["topic"], []).append(x)
        best = max(groups.values(), key=len)
        best = sorted(best, key=lambda x: x["turn"])
        return best
    return matched

if __name__ == "__main__":
    items = json.load(open("zhiniao_data.json", encoding="utf-8"))
    fp = "/Users/zhoujiale/Library/Mobile Documents/com~apple~CloudDocs/知鸟话术音频/Mac/MacBook Neo常见问题 (202603).mp3"
    group = match_rows("MacBook Neo常见问题 (202603)", items)
    print(f"=== 匹配到话术组: {len(group)} 行 ===")
    for x in group:
        print(f"  [{x['id']}] turn={x['turn']} | {x['topic'][:42]!r}")
    turns, expected, segs = analyze_file(fp, group)
    print(f"\n语音段数(边界): {len(turns)} | 期望角色数: {len(expected)}")
    print("\n=== 边界(全部) ===")
    for i, (s, e, g) in enumerate(turns):
        print(f"  段{i+1:2d}: {s:6.1f}-{e:6.1f}s 时长{e-s:4.1f}s 检测性别={g}")
    print("\n=== 对齐结果（语音段 → 角色）===")
    mismatch = 0
    for i, sg in enumerate(segs):
        icon = "👩" if sg["role"] == "female" else ("👨" if sg["role"] == "male" else "❓")
        dg = sg["dgender"]
        flag = ""
        if sg["role"] == "female" and dg == "M":
            flag = "  ⚠️检测男/期望女"; mismatch += 1
        elif sg["role"] == "male" and dg == "F":
            flag = "  ⚠️检测女/期望男"; mismatch += 1
        print(f"  {i+1:2d}. {icon}{sg['role']:6s} {sg['start']:6.1f}-{sg['end']:6.1f}s [{sg['rowId']}] {sg['text'][:28]}{flag}")
    if len(turns) > len(expected):
        print(f"\n⚠️ 语音段比期望多 {len(turns)-len(expected)} 段（可能为开场/结尾或额外内容，未映射最后若干段）")
    elif len(expected) > len(turns):
        print(f"\n⚠️ 期望角色比语音段多 {len(expected)-len(turns)} 个（部分话术可能在另一段录音或未被录到）")
    if mismatch:
        print(f"\n⚠️ 性别检测与结构规则冲突 {mismatch} 处（录音音高接近或切分误差，建议人工校正）")
