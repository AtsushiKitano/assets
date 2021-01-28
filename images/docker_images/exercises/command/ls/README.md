ls コマンドのイメージ
==

## 概要

特定のパスにあるファイルの一覧表示をする。(ls pathを実行する)

## 実行方法

内容を確認したいパスを絶対パスで渡すと、標準出力で結果が得られる。

1. docker build
1. docker run

```
docker build -t <container image name> .
docker run -v <local path>:/volume <image name> --name <container name>
```
