#!/usr/bin/env python3
# build.yml の assets の job から呼ぶ。手元でも repo の根で `python3 scripts/check-ja-version.py` で同じ検査になる。
#
# browserhive-specs では、前の版の訳を写して次の版を作ったとき冒頭の版を直し忘れ、5 版に
# 写り続けた（2026-11-01 に訂正）。latest/ja/ は latest/index.html の title の版と比べる。
import glob, os, re, sys
title = os.environ.get("TITLE", "BrowserHive WARC Profile")
checked = bad = 0
for p in sorted(glob.glob(os.environ.get("JA_DOCS", "*/ja/index.html"))):
    version_dir = os.path.dirname(os.path.dirname(p))
    version = os.path.basename(version_dir)
    if version == "latest":
        en = open(os.path.join(version_dir, "index.html"), encoding="utf-8").read()
        t = re.search(r"<title>" + re.escape(title) + r" ([0-9.]+)</title>", en)
        want = t.group(1) if t else None
    else:
        want = version
    m = re.search(r"これは " + re.escape(title) + r" ([0-9.]+) の日本語訳です", open(p, encoding="utf-8").read())
    checked += 1
    if m is None or want is None:
        print(f"::error file={p}::冒頭の「これは {title} N の日本語訳です」か、比べる版が見つからない")
        bad += 1
    elif m.group(1) != want:
        print(f"::error file={p}::冒頭は {m.group(1)} の日本語訳と書くが、置き場の版は {want}")
        bad += 1
print(f"ja の冒頭: {checked} 本")
if checked == 0:
    print("::error::ja の原稿を 1 本も見つけられない。何も見ていない緑にしない")
    bad += 1
sys.exit(1 if bad else 0)
