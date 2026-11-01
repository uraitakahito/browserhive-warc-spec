# browserhive-warc-spec

[BrowserHive](https://github.com/uraitakahito/browserhive) が書き出す WARC ファイルの仕様
（BrowserHive WARC Profile）。[WARC 1.1](https://iipc.github.io/warc-specifications/specifications/warc-format/warc-1.1/)
の上に、BrowserHive がどのレコードをどの形で書くかを定める。最初の版（1.0.0）を準備している。

WACZ パッケージとしての決まり（`datapackage.json`・索引・`archive/` の名前と並び）は
[browserhive-specs](https://github.com/uraitakahito/browserhive-specs) の BrowserHive WACZ Profile に在る。

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
