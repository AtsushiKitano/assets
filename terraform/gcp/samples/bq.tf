locals {
  bq_sample_enable = false

  _bq_enable = local.bq_sample_enable ? ["enable"] : []
}

module "bq_sample" {
  for_each = toset(local._bq_enable)
  source   = "../modules/bigdata/bq"

  dataset = {
    dataset_id                  = "sample"
    location                    = "asia-northeast1"
    default_table_expiration_ms = 36000000
  }
}

output "bq_sample_output" {
  value = module.bq_sample
}
