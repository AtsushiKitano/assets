GCPインフラ設定値収集ツール
===

# 概要

GCPの各種設定値を収集するツール

# 使い方

1. main.shのPROJECTSに操作対象のプロジェクト名の入力
1. 出力先のディレクトリ名を指定し、main.shを下記のように実行する

例) logsディレクトリに設定値の情報を収集する

```
sh main.sh logs
```

上記、実行ディレクトリにlogsディレクトリを作成し、設定値ファイルを作成する。

# 出力内容

GCP コンポーネントの各種設定値を記載したファイルが格納される。  
- CSVディレクトリ: 操作対象のすべてのプロジェクトの各コンポーネントの設定値を抽出した値が保存される
- JSONディレクトリ: 各リソースの生の設定値が格納される。命名規則は、リソース名-プロジェクト名.jsonとなる。

実行後のディレクトリ構成は下記の通りとなる。

```
logs
├── csv
│   ├── build_trigger.csv
│   ├── cloud_nat.csv
│   ├── cloud_router.csv
│   ├── cloud_sql.csv
│   ├── dns_record.csv
│   ├── functions.csv
│   ├── gce.csv
│   ├── gce_disk.csv
│   ├── gke_cluster.csv
│   ├── gke_node.csv
│   ├── health_check.csv
│   ├── http_health_check.csv
│   ├── https_health_check.csv
│   ├── instance_group.csv
│   ├── instance_template.csv
│   ├── keys.csv
│   ├── kmsrings.csv
│   ├── logging_sink.csv
│   ├── memorystore.csv
│   ├── pubsub_subscription.csv
│   ├── pubsub_topics.csv
│   ├── route.csv
│   ├── scheduler.csv
│   ├── snapshot.csv
│   ├── source_repositories.csv
│   ├── ssl_certificate.csv
│   ├── subnet.csv
│   ├── url_map.csv
│   ├── vpc_network.csv
│   ├── vpn_gateway.csv
│   └── vpn_tunnel.csv
└── json
    ├── armor
    │   ├── 
    │   ├── 
    │   ├── 
    │   ├── 
```

