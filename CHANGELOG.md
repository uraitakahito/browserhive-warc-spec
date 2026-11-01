# 変更履歴

BrowserHive WARC Profile の版ごとの変更。

**各版は後方互換ではない。** BrowserHive は最新版しか出力しないが、古い版の文書は
それぞれの URL に残す —— 既存の WARC ファイルの warcinfo の `conformsTo` がそこを指しており、
消すと「何に適合していたか」を辿れなくなるため。

| 版 | 日付 | 一言で |
|---|---|---|
| [1.0.0](https://uraitakahito.github.io/browserhive-warc-spec/1.0.0/) | 2026-11-01 | 最初の版。BrowserHive WACZ Profile 1.15.0 から WARC のレコードの決まりを移す |

---

## 1.0.0

最初の版。これまで [BrowserHive WACZ Profile](https://uraitakahito.github.io/browserhive-specs/wacz-profile/1.15.0/)
の中に在った WARC のレコードの決まりを移し、WARC ファイルが自分で名乗れるようにした。

- **移した決まり:** payload（wire を渡ったバイト列のまま）・body not kept のレコード・
  withheld request のレコード・window not opened のレコード（WACZ Profile の windows の節の後半）・
  各ファイルの先頭の warcinfo・1 つのレコードは 2 本にまたがらない・1 交信は同じ本・
  response の payload は HTTP/1.1 の形。
- **設定の名前を使わない:** `truncated` の値と `action` の値を、producer の上限と方針の言葉で
  定める。どの設定（`maxResponseBytes`・`urlPolicies` など）がそれにあたるかは WACZ Profile 1.16.0 が言う。
- **新しく定めたこと:**
  - warcinfo の `conformsTo` で、この仕様の版を 1 つだけ名乗る（`format` は `WARC File Format 1.1`）。
  - 交信の定義（`WARC-Concurrent-To` で互いを名指す request と response、それに本文を持たない
    応答の記録）。
  - 1 交信のレコードは同じ `WARC-Date` を持ち、それはブラウザがリクエストを始めた時刻
    （WARC 1.1 の「取り込みが始まった瞬間・1 つの出来事は同じ日時」に合わせる。BrowserHive は
    v22.0.1 からこの形で書く）。
- **WACZ Profile に残したもの:** `archive/` の名前と連番・切り替え・索引・どの設定がどの記録を
  作るか・ウィンドウを開かせないこと。
