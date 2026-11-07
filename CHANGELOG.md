# 変更履歴

BrowserHive WARC Profile の版ごとの変更。

**各版は後方互換ではない。** BrowserHive は最新版しか出力しないが、古い版の文書は
それぞれの URL に残す —— 既存の WARC ファイルの warcinfo の `conformsTo` がそこを指しており、
消すと「何に適合していたか」を辿れなくなるため。

| 版 | 日付 | 一言で |
|---|---|---|
| [1.2.0](https://uraitakahito.github.io/browserhive-warc-spec/1.2.0/) | 2026-11-07 | 隠すシークレットの値を、`request`・`response` のレコードの中で `***` に置き換える |
| [1.1.0](https://uraitakahito.github.io/browserhive-warc-spec/1.1.0/) | 2026-11-02 | 写し（取り込みの時点ごとの文書の DOM）を `resource` と `metadata` の組で足す |
| [1.0.0](https://uraitakahito.github.io/browserhive-warc-spec/1.0.0/) | 2026-11-01 | 最初の版。BrowserHive WACZ Profile 1.15.0 から WARC のレコードの決まりを移す |

---

## 1.2.0

隠すシークレットの値を、`request` と `response` のレコードの中で `***` に置き換えるようにした。
置き換えはレコードの数も型も変えない。文字でない本文を落とすときだけ、body not kept のレコードが増える。

- **シークレットと隠すシークレット:** シークレットの定義を、写しの節から新しい節 `redacted-records`
  へ移した。隠すシークレットは、取り込みを求めた側が残すことを求めなかったシークレットで、値は
  少なくとも 8 文字。それより短い値を、残すことを求めずに渡す要求は、producer が断る。
- **redacted のレコード:** 認識できた出現（値そのままのほか、URL・form・JSON・HTML・base64 の綴りと、
  HTTP の Basic 認証の認証情報、base64 の `data:` URL のデータの全体）を、`WARC-Target-URI`・
  リクエスト行・HTTP のヘッダの欄の値・文字の本文の中で `***` に置き換える。ファイルのほかのどこにも
  出現を書かない。
- **`BrowserHive-Redacted`:** redacted のレコードが自分で名乗る欄。形は
  `BrowserHive-Redacted: target-uri=1, headers=1, payload=2` で、置き換えが 1 つ以上ある part だけを
  書く。ほかの型のレコードは持たず、この欄の無い `request`・`response` は値を置き換えていない。
- **digest と長さ:** redacted のレコードと本文を落としたレコードの `Content-Length`・
  `WARC-Block-Digest`・`WARC-Payload-Digest`（HTTP の `Content-Length` も）は、レコードが持っている
  バイト列を述べる。置き換える前のバイト列や落とした本文の digest は書かない（持っているバイト列と
  合わせると、値の候補を試せてしまう）。
- **文字でない本文:** 中を置き換えず、本文なしで記録して `WARC-Truncated: secret` を書く。`response` は
  body not kept のレコードの `truncated: secret` も持つ。文字の本文は `text/*`・JSON・XML・JavaScript・
  `application/x-www-form-urlencoded`。
- **Cookie:** 隠すシークレットの値を載せた要求への応答が返した `Set-Cookie` の値（8 文字以上）は、
  その応答が届いた瞬間から、隠すシークレットの値として扱う。
- **追わないもの:** 値から作ったもの（ハッシュ・暗号文）と、応答の本文で新しく発行された資格（JSON の
  token）は出現ではない。この仕様は、それらが無いことを主張しない。
- **直した節:** Conformance と Introduction（redacted のレコードが WARC 1.1 の勧告から外れ、
  `WARC-Target-URI` も値を置き換えた形になること）・Payloads（redacted のレコードを除く）・
  Records of bodies not kept（`truncated` に `secret`）・Security。Exchanges は変えない。
- **metadata の URL:** body not kept・withheld request・window not opened のレコードの
  `WARC-Target-URI` は、隠すシークレットの値を置き換えた形。これらのレコードは `BrowserHive-Redacted` を
  持たないので、読み手はそこの `***` と URL の中の同じ字とを区別できない。
- **写しの URL（1.1.0 の記述の訂正）:** 写しの `document-uri`・`WARC-Target-URI`・`base` の `href` は、
  シークレットの値を置き換えた形。BrowserHive は 1.1.0 からこの形で書いていて、1.1.0 の文
  （"as the browser held it"）が実物と違っていた。`secrets-replaced` は写しの中の置き換えだけを数える。
- **写しの中のシークレット:** 隠すものかどうかに関わらず、そのままの形と HTML の escape の形を持たない
  と明記した。隠すシークレットは、ほかの綴りも持たない。

## 1.1.0

取り込みの 2 つの時点（読み込んで落ち着いた後と、behavior の後）で、ページの文書を写して
WARC に残せるようにした。replay の読み手は、写しを手持ちのページと同じように一覧に載せて配る。

- **写し（snapshot）:** 写しを block に持つ `resource` レコード（`Content-Type: text/html; charset=utf-8`・
  `WARC-Block-Digest` と `WARC-Payload-Digest`）と、それを `WARC-Refers-To` で指す `metadata`
  レコード（本文の欄 `snapshot`・`document-uri`・`document-record`・`secrets-replaced`）。
  2 つは同じファイルに書き、`WARC-Concurrent-To` は付けない。時点ごとに高々 1 つ。
- **写しの URI:** `WARC-Target-URI` は `urn:browserhive:snapshot:<時点>:<文書の URL（fragment を除く）>`。
  WARC 1.1 は `resource` の http・https の target URI を、その URI に対して返されたもののために
  とっておき、収集のほかの成果物には合成した URI を用意している（§6.4）。写しはサーバが返した
  ものではないので、合成した URI に置く。文書の URL のままだと、読み手は写しをサーバの返した
  ものと取り、replay は同じ秒の応答と取り違える。
- **写しの中身:** head の最初の要素は、文書の base URL を持つ `base`（写しは自分の URI で
  配られるので、相対 URL をページの中と同じに解決させる）。どの名前空間の `script` 要素も、
  `on` で始まる属性も、`srcdoc` も持たず、URL の属性に `javascript:void(0)` のほかの
  `javascript:` を持たない。パスワードの欄は `value` を持たない。シークレットの値は、
  そのままの形でも HTML の escape の形でも持たない。
- **読み手への決まり:** 写しの `metadata` を、withheld request・body not kept・window not opened
  のレコードとして数えない。写しをオリジンが送ったものと取らない。
- **作り方の注記（informative）:** isolated world で読む・欄の値を属性に・shadow root を
  `template` に・canvas を画像に・フレームの `src` はそのまま・doctype はもとのまま。

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
