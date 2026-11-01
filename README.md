# browserhive-warc-spec

[BrowserHive](https://github.com/uraitakahito/browserhive) が書き出す WARC ファイルの仕様
（BrowserHive WARC Profile）。[WARC 1.1](https://iipc.github.io/warc-specifications/specifications/warc-format/warc-1.1/)
の上に、BrowserHive がどのレコードをどの形で書くかを定める。

| 仕様 | 版 | 日本語訳 |
|---|---|---|
| [BrowserHive WARC Profile](https://uraitakahito.github.io/browserhive-warc-spec/1.0.0/) | **1.0.0** | [あり](https://uraitakahito.github.io/browserhive-warc-spec/1.0.0/ja/) |

各版は**後方互換ではない**。BrowserHive は最新版しか出力しないが、古い版の文書は
それぞれの URL に残す —— 既存の WARC ファイルの warcinfo の `conformsTo` がそこを指しており、
消すと「何に適合していたか」を辿れなくなるため。版ごとに何が変わったかは[変更履歴](CHANGELOG.md)。

版を固定せず参照するなら
[`latest/`](https://uraitakahito.github.io/browserhive-warc-spec/latest/)
（[日本語](https://uraitakahito.github.io/browserhive-warc-spec/latest/ja/)）。
その時点で最新の版の写しで、各版の文書がヘッダの「最新バージョン」としてここを指す。
転送ではないので、新しい版を出すときは、その版の `index.html` と `ja/index.html` で上書きする。

正典は英語版。訳は非公式で、食い違った場合は英語版が優先する。

WACZ パッケージとしての決まり（`datapackage.json`・索引・`archive/` の名前と並び）は
[browserhive-specs](https://github.com/uraitakahito/browserhive-specs) の BrowserHive WACZ Profile に在る。
WACZ Profile 1.16.0 から、`archive/` の WARC ファイルはこの仕様の版に適合し、warcinfo でその版を名乗る。

WARC 1.1 の本文は写さない。WARC 1.1 の正典は ISO 28500:2017 で、IIPC の頁にもライセンスが無い。
この仕様は WARC 1.1 を節の名前と URL で指す。

## 作り方

原稿は [ReSpec](https://respec.org/docs/)。GitHub Pages が `main` の根をそのまま配り、ReSpec は
読者のブラウザで走る。ReSpec は w3.org から読まず、`assets/js/respec-w3c.js` に同梱している
（`respec-drift` の workflow が週 1 回、上流と比べる）。

CI（`.github/workflows/build.yml`）は公開の経路に居らず、検査だけをする:

- 各版を `w3c/spec-prod` で焼けること（markup の検査を含む）
- 同梱の ReSpec が各原稿から解決すること
- 最新の版（`latest/`）の節が、原稿に id を持つこと
- 著者が書いたリンクが 200 を返すこと

ローカルで見るには `1.0.0/index.html` をブラウザで開く。
