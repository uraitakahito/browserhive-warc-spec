# 変更履歴

BrowserHive WARC Profile の版ごとの変更。

**各版は後方互換ではない。** BrowserHive は最新版しか出力しないが、古い版の文書は
それぞれの URL に残す —— 既存の WARC ファイルの warcinfo の `conformsTo` がそこを指しており、
消すと「何に適合していたか」を辿れなくなるため。

| 版 | 日付 | 一言で |
|---|---|---|
| [1.4.0](https://uraitakahito.github.io/browserhive-warc-spec/1.4.0/) | 2026-11-14 | 適合するファイルの呼び名「BrowserHive WARC」を定義し、ファイル名から適合を推さないことを書く。決まりは 1.3.0 と同じ |
| [1.3.0](https://uraitakahito.github.io/browserhive-warc-spec/1.3.0/) | 2026-11-14 | スクリーンショット（取り込みの時点ごとの viewport の画像）を `resource` と `metadata` の組で足す |
| [1.2.0](https://uraitakahito.github.io/browserhive-warc-spec/1.2.0/) | 2026-11-07 | 隠すシークレットの値を、`request`・`response` のレコードの中で `***` に置き換える |
| [1.1.0](https://uraitakahito.github.io/browserhive-warc-spec/1.1.0/) | 2026-11-02 | 写し（取り込みの時点ごとの文書の DOM）を `resource` と `metadata` の組で足す |
| [1.0.0](https://uraitakahito.github.io/browserhive-warc-spec/1.0.0/) | 2026-11-01 | 最初の版。BrowserHive WACZ Profile 1.15.0 から WARC のレコードの決まりを移す |

---

## 1.4.0

この仕様に適合する WARC ファイルを指す呼び名を定め、BrowserHive の WARC ファイルの名前が変わる
（BrowserHive WACZ Profile 1.25.0 が、パッケージの中の名前を `data-NNN.browserhive.warc.gz` にする）
のに合わせて、名前と適合の関係を書いた。ファイルに求める決まりは 1.3.0 と同じで、変わるのは
warcinfo の `conformsTo` が名指す版だけ。

- **呼び名（Conformance）:** この仕様に適合する WARC ファイルを `BrowserHive WARC` ファイルと呼ぶ。
  適合しない WARC ファイルも WARC ファイルで、この仕様はそれについて何も述べない。
- **Conformance の文の直し:** 1.3.0 は「要求を取り除かず、緩めない」の直後に「redacted record は
  WARC 1.1 の言うことから外れる」と書き、2 つが食い違って読めた。外れるのは WARC 1.1 が勧める・述べる
  こと（request・response の block が持つもの・`WARC-Target-URI` が元の URI であること）からで、
  求めることからではない、と 1 つの文にした。
- **適合はファイルの名前から推さない（warcinfo）:** 「`conformsTo` 以外から推してはならない」に、
  ファイルの名前を挙げた。名前の印（`data-000.browserhive.warc.gz`）は手がかりで、名乗りではない。
- **例:** warcinfo の例の `WARC-Filename` を `data-000.browserhive.warc.gz` に、`software` を
  `browserhive/31.0.0` に（見出しと同じ長さの字なので `Content-Length` は 203 のまま）。
- **WACZ Profile への参照:** 版を固定せず `latest/` のまま（WACZ Profile 1.25.0 は、この版の公開の後に出る）。

## 1.3.0

取り込みの時点（読み込んで落ち着いた後・behavior の後）で、ブラウザが取り込みのページを
viewport の中にどう表示していたかを、画像にして WARC に残せるようにした。形は写し（1.1.0）と同じ、
`resource` と `metadata` の組。

- **スクリーンショット（screenshot）:** 画像を block に持つ `resource` レコード（`Content-Type: image/webp`・
  `WARC-Block-Digest` と `WARC-Payload-Digest`）と、それを `WARC-Refers-To` で指す `metadata`
  レコード（本文の欄 `screenshot`・`document-uri`・`document-record`・`viewport`・`device-pixel-ratio`・
  `image-size`）。2 つは同じファイルに書き、同じ `WARC-Date`（取った瞬間）を持ち、`WARC-Concurrent-To` は
  付けない。時点ごとに高々 1 つ。
- **組の一貫性:** `screenshot` の値は `WARC-Target-URI` の中の時点と同じで、`WARC-Target-URI` の中の
  URL は `document-uri` から fragment を除いたもの。`WARC-Target-URI` が `urn:browserhive:screenshot:` で
  始まる `resource` には、それを `WARC-Refers-To` で名指すこの `metadata` が、ちょうど 1 つ在る。
- **欄の書式:** `viewport` と `image-size` は `count "x" count`（幅・小文字の x・高さ。`count` は
  `nonzero *DIGIT` = 1 以上で、先頭に 0 を付けない）。`device-pixel-ratio` は
  `( nonzero *DIGIT [ "." *DIGIT nonzero ] ) | ( "0" "." *DIGIT nonzero )`（0 より大きく、指数を
  使わず、省ける 0 を書かない。整数は小数部を持たない）。`nonzero` は 1 から 9 の数字。
- **時点:** `after-load`・`after-behaviors`（写しの時点と同じ名前）。
- **スクリーンショットの URI:** `WARC-Target-URI` は
  `urn:browserhive:screenshot:<時点>:<文書の URL（fragment を除く）>`。シークレットの値は、写しの URI と
  同じく置き換えた形。オリジンが文書の URL に対して返したものと取り違えられないように、また、同じ文書の
  スクリーンショットどうしと写しを URI で分けられるように、合成した URI に置く。
- **画像:** WebP。viewport を写し、その先（scroll して初めて見えるところ）は写さない —— viewport の先を
  写そうとすると、取り込みのページが、画像のためだけに配置や取得をすることになる。画像の大きさは定めない:
  `image-size` は block の画像自身が持つ幅と高さを述べ、画像の pixel 1 つが CSS pixel 1 つに当たるとは
  限らない。`device-pixel-ratio` は、そのページがどの密度の画面に向けて描かれていたかを述べ、画像の倍率では
  ない（倍率は `image-size` と `viewport` の比）。
- **画像が写す状態:** 画像は、producer がスクリーンショットを取り始めたときに取り込みのページが持っていた
  viewport の大きさ・device pixel ratio・scroll の位置で、そのページを写す。画像のためにそのどれかを
  変えると、元に戻すとしても、そのページに何かをさせ、それが後に続くレコードに残るため。
- **読み手への決まり:** スクリーンショットの `metadata` を、withheld request・body not kept・window not
  opened のレコードや、写しの `metadata` として数えない。画像をオリジンが送ったものと取らない。
  `screenshot` の値は閉じた集合ではないが、この版に適合するファイルが持つのは 2 つの時点だけ。知らない値を
  持つ `metadata` が述べる画像を、ある時点のスクリーンショットとして扱わない。
- **withheld request の `no-archive`（記述の訂正）:** `action` の説明から「オリジンは答えた」を外した。
  レコードが言うのは、producer がリクエストを通し、この記録のほかには交信の何も残さなかったことで、
  レスポンスが在ったことではない。
- **直した節:** Records and files（スクリーンショットの 2 つのレコードも同じファイル）・Introduction・
  Security（スクリーンショットは、ファイルがレスポンスを持っているかどうかに関わらず、取り込みのページが
  描いたものの中身を写す。画像の中の値は置き換えられない）。
- **この仕様が定めないこと:** どの取り込みがスクリーンショットを残さないかは、ファイルを収めるパッケージの
  決まり（BrowserHive WACZ Profile）。

## 1.2.0

隠すシークレットの値を、`request` と `response` のレコードの中で `***` に置き換えるようにした。
置き換えはレコードの数も型も変えない。文字でない本文を落とすときだけ、body not kept のレコードが増える。

- **シークレットと隠すシークレット:** シークレットの定義を、写しの節から新しい節 `redacted-records`
  へ移した。隠すシークレットは、取り込みを求めた側が残すことを求めなかったシークレットで、値は
  少なくとも 8 文字（UTF-16 の code unit で数える）。それより短い値を、残すことを求めずに渡す要求は、producer が断る。
- **redacted のレコード:** 認識できた出現（値そのままのほか、URL・form・JSON・HTML・base64 の綴りと、
  `Authorization`・`Proxy-Authorization` の欄の Basic 認証の認証情報、base64 の `data:` URL のデータの全体）を、`WARC-Target-URI`・
  リクエスト行・HTTP のヘッダの欄の値・文字の本文の中で `***` に置き換える。ファイルのほかのどこにも
  出現を書かない。`WARC-Target-URI` は URI のままにし、置き換えると scheme が無くなるときは元の scheme
  とコロンを前に書く。それでも URI にならないときは scheme とコロンと `***` だけを書く。
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
