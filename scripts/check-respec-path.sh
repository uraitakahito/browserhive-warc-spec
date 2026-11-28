#!/usr/bin/env bash
# build.yml の assets の job から呼ぶ。手元でも repo の根で `bash scripts/check-respec-path.sh` で同じ検査になる。
# -eo pipefail は GitHub Actions の既定の bash（`bash -eo pipefail {0}`）と同じにするため。
set -euo pipefail

# 閲覧者のブラウザで描く以上、script が引けなければページは崩れる。崩れても HTTP は 200
# なので、公開の後に気づく手立てが無い。同じオリジンに置いてあるので、壊れ方は「ファイルが
# 無い」か「パスが違う」の 2 つしかなく、どちらもブラウザを起こさずに確かめられる。
#
# 見る原稿は版の置き場（数字で始まる dir）の glob と latest/ で拾う。以前は版を手で並べていたが、
# 版を出すたびにその一覧を直さねばならなかったので glob に替えた（t-fcp8）。
FAIL=0
for doc in [0-9]*/index.html [0-9]*/ja/index.html \
           latest/index.html latest/ja/index.html; do
  src=$(grep -o 'src="[^"]*respec[^"]*"' "$doc" | sed 's/src="//; s/"$//')
  if [ -z "$src" ]; then
    echo "::error::$doc が ReSpec を読み込んでいない"
    FAIL=1
    continue
  fi
  target="$(dirname "$doc")/$src"
  if [ -f "$target" ]; then
    echo "  ok   $doc -> $src"
  else
    echo "::error::$doc -> $src が解決しない"
    FAIL=1
  fi
done
exit $FAIL
