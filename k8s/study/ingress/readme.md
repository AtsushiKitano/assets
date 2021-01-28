Ingressにつての調査
===

## 概要

Service にルーティングする HTTP(S) エンドポイントを作る

### 構築

Serviceを1つ以上含めて作成する必要がある。
当該Serviceのタイプは、NodePortである必要がある。

### Ingressの構成要素

- apiVersion: string
- kind: string
- metadata: ObjectMeta
- spec: IngressSpec
- status: Ingress Status

#### IngressSpecの構成要素

- backend(型IngressBackend): ルールにマッチしないリクエストに対して応答する。backendかruleのどちらかを必ず定義する必要がある。
- rules(型IngressRule): 
- tls(型IngressTLS):

##### IngressBackendの構成要素

- serviceName: 参照するサービス名
- servicePort: 参照するサービスのポート番号

##### IngressRuleの構成要素

- host(型: string)
- http(型: HTTPIngressRuleValue)

###### HTTPIngressRuleValueの構成要素

- paths(型: []HTTPIngressPath)

####### HTTPIngressPathの構成要素

- backend(型IngressBackend)
- path(型string)

#### IngressStatusの構成要素

- 概要: Ingressの現在の状態
- items: ingress array
- kind
- metadata: ListMeta
