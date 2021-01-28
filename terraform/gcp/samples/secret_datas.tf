locals {
  secret_datas_enable = true

  _secret_datas = local.secret_datas_enable ? ["enable"] : []
}

module "secret_data_sample" {
  for_each = toset(local._secret_datas)
  source   = "../modules/security/secret_datas"

  secret_datas = {
    sample = "CiQAipVp7YFaMPK3cOUH0bklg4ad33qPCPckisFPZ4QfUcxvbX0SLwCnBefe2e4jnaqUa+1GPiiGDrSE3PztKlPAUdYW5EB+hSrvKXKDNWPaLpjeYqN4"
  }

  key_infos = {
    keyring  = "common-env-keys"
    key      = "asia-northeast-demo-key"
    location = "asia-northeast1"
  }
}

output "secret_data_sample" {
  value = module.secret_data_sample["enable"].plaintext.sample
}
