Armor Module
===

# 使い方

1. filesフォルダにアクセス制御するIPアドレスのリストファイルを格納する

## IPアドレス管理ファイルの形式

IPアドレスを管理するファイルの形式を下記のいずれかとする

- json
- yaml
- csv

### IPアドレス管理ファイルの内容

key、アドレスで管理し、var.files_rule.ip_prefixにkey値を記入する。
var.files_rule.ip_prefix= "ipAddress"ならば下記のように管理する。

```
[
{
"ipAddress": "xx.xx.xx.xx",
..
},
{
"ipAddress": "xx.xx.xx.xx",
..
}
]
```
