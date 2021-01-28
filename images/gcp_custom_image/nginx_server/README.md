Nginxのカスタムイメージ作成
===

# 概要

Packerを使いGCP上にnginxのカスタムイメージの作成

# 使い方

## カスタムイメージの作成
```
gcloud builds submit .
```

## カスタムイメージのテスト

- テスト用の外部アドレスの確保
```
gcloud compute addresses create <address name>
```
-  test.yamlに先に取得した外部IPに合うよう_ADDRESSと_STATIC_ADDRESSを変更
- テストの実行
```
gcloud builds submit --config=test.yaml
```
