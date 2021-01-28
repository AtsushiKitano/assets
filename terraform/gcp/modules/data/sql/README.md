Cloud SQLの使い方
===

# 接続方法

## sql proxy

- TCPソケット
```
cloud_sql_proxy -instances=ca-kitano-study-sandbox:asia-northeast1:demo-psgre-proxy=tcp:5432 -credential_file=$GOOGLE_APPLICATION_CREDENTIALS
psql -h localhost -U postgres -p 5432
```
- Unixソケット
```
cloud_sql_proxy -dir=~/tmp/cloudsql
psql "sslmode=disable host=/Users/kitano/tmp/cloudsql/ca-kitano-study-sandbox:asia-northeast1:demo-psgre-proxy user=postgres"
```

