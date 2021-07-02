# BboLang

## 文法

``b`` ``o`` ``B`` ``O``の4文字のみで表記する。大文字小文字の区別あり。
スペース・改行などは全て無視して何も意味を持たないため、命令ごとに改行して表記するかどうか、パラメータと命令の間に空白を入れるかどうかは自由。

### 命令一覧

|Name     |OpCode|Param|Detail|
|---------|------|-----|------|
|ADD      |bbbb  |-    |スタックの(2番目)+(1番目)|
|SUB      |bbbo  |-    |スタックの(2番目)-(1番目)|
|MUL      |bbob  |-    |スタックの(2番目)*(1番目)|
|DIV      |bboo  |-    |スタックの(2番目)/(1番目)|
|PUSH     |bobb  |[数値リテラル](#数値リテラル)|スタックにプッシュ|
|POP      |bobo  |-    |スタックトップを破棄|
|ECHO_CHAR|oobb  |-    |スタックトップを文字として標準出力(数値をASCIIコードで文字に変換)|
|ECHO_INT |oobo  |-    |スタックトップを数字として標準出力|

### リテラル

``B``で囲うとリテラルを表す。

#### 数値リテラル

``b``が1、``o``が0を表し、2進数で表記。
(例) ``BboobB`` => ``1001`` => ``9``

## 実行

Nimbleを利用してインタプリタをビルドします。

```shell-session
$ git clone https://github.com/bbo51dog/BboLang.git
Cloning into 'BboLang'...
~~~
$ cd BboLang
$ nimble build
  Verifying dependencies for bbolang@x.x.x
   Building bbolang/bbolang using c backend
```

ビルド後、``BboLang/bin/``下に実行可能ファイルが作成されます。
``nimble insatall``でインストールすれば他ディレクトリからでも使えます。

```shell-session
$ nimble install
  Verifying dependencies for bbolang@x.x.x
 Installing bbolang@x.x.x
   Building bbolang/bbolang using c backend
   Success: bbolang installed successfully.
```

BboLang実行

```shell-session
$ bbolang example.bbolang
 output...
```

## Example

### HelloWorld

```text
bobbBbooboooB
oobb
bobbBbboobobB
oobb
bobbBbbobbooB
oobb
bobbBbbobbooB
oobb
bobbBbbobbbbB
oobb
bobbBbobbooB
oobb
bobbBboooooB
oobb
bobbBbobobbbB
oobb
bobbBbbobbbbB
oobb
bobbBbbbooboB
oobb
bobbBbbobbooB
oobb
bobbBbboobooB
oobb
bobbBboooobB
oobb
```

```shell-session
$ bbolang HelloWorld.bbolang
Hello, World!
```

``bobbB~~B``でスタックに文字コードをpushし、oobbで文字を出力。
(ループが実装されていないため1文字毎に出力。いつかラベルなど実装するかもしれません。)

### 四則演算

```text
bobbBbboB
bobbBbooB
bbob
bobbBbbB
bbbb
oobo
```

```shell-session
$ bbolang Calculate.bbolang
27
```

``6 * 4 + 3``の結果を出力。
