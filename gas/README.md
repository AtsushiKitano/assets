claspでGASコードの管理方法
==

claspは、 Apps Scriptをローカル環境で開発するツールである。
[Google](https://github.com/google/clasp)が開発するツールである

## 使い方

1. Google アカウントへのログイン
1. プロジェクトの初期化
1. コードのデプロイ

### Google アカウントへのログイン

```
clasp login
```

### プロジェクトの初期化

```
clasp create --rootDir $PWD
```

実行すると、Google Workspaceのmydriveに対象のドキュメントが作成し、ローカルに以下のファイルが作成される。

- `.clasp.json`: GASファイルのID、ローカルのパス、対象のドキュメントのID 
- `appsscript.json`: タイムゾーン、依存関係、ログの出力先、ランタイムバージョン

[.clasp.json]
```json
{
  "scriptId": <AppscriptのID (GASのURLで表示される部分)>,
  "rootDir": <GASを作成するコードのパス>,
  "parentId":[
    <Appscriptを適用するドキュメントのID (ドキュメントのURLで表示される部分)>
	]
  }
```

[appsscript.json]
```json
{
  "timeZone": "America/New_York",
  "dependencies": {
  },
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8"
}
```

### コードのデプロイ

```
clasp push
```
