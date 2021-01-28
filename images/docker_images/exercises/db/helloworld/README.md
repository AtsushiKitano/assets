MySql DBの作成
===

# 概要
mysqlインスタンスを起動するコンテナの作成。
DBの書込み情報をdataディレクトリに格納する。

# 使い方

```
mkdir data
docker-compose up
mysql -u root -p -h localhost -P 3306 --protocol=tcp
```
