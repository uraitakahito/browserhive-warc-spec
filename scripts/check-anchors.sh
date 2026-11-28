#!/usr/bin/env bash
# build.yml の assets の job から呼ぶ。手元でも repo の根で `bash scripts/check-anchors.sh` で同じ検査になる。
# -e は、GitHub Actions の run の既定の shell（shell を書かない時の `bash -e {0}`。pipefail は付かない）と同じにするため（review-16）。
set -e

# browserhive の要求の目録は、この仕様の節を錨で指し、その錨が在るかをブラウザを起こさずに
# 原稿から読む。ReSpec は id の無い section にも描くときに見出しから id を作るが、それは
# 原稿には現れないので、静的に読む側からは見えない。
#
# 見るのは latest/ だけ。新しい版を出すときは latest/ をその版で上書きするので、ここが
# いつも最新の版になる。
#
# Conformance の節だけは id を書かない。ReSpec は section#conformance を特別に扱い、書くと
# RFC 2119 の定型文が入り、参考文献が Informative から Normative に変わる（browserhive-specs
# の 1.14.0 で試した）。描画を変えずには書けない。
FAIL=0
for doc in latest/index.html latest/ja/index.html; do
  perl -0777 -ne '
    my $bad = 0;
    while (/<section\b(?![^>]*\bid=)[^>]*>\s*(?:<h([2-6])\b[^>]*>(.*?)<\/h\1>)?/gs) {
      my $t = defined $2 ? $2 : "(見出しが無い)";
      $t =~ s/<[^>]+>//g;
      next if $t eq "Conformance";
      print "::error file=${ARGV}::id の無い section: $t\n";
      $bad = 1;
    }
    while (/<h([2-6])\b[^>]*>(.*?)<\/h\1>/gs) {
      my $start = $-[0];
      my $t = $2;
      $t =~ s/<[^>]+>//g;
      next if substr($_, 0, $start) =~ /<section\b[^>]*>\s*\z/;
      print "::error file=${ARGV}::section の最初の子でない見出し: $t\n";
      $bad = 1;
    }
    exit $bad;
  ' "$doc" && echo "  ok   $doc" || FAIL=1
done
exit $FAIL
