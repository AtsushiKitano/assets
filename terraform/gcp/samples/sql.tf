locals {
  sql_sample_enable = false

  _sql_enable = local.sql_sample_enable ? ["enable"] : []
}

module "sql_sample" {
  for_each = toset(local._sql_enable)
  source   = "../modules/data/sql"

  sql_instance = {
    name             = "sample"
    database_version = "POSTGRES_11"
    region           = "asia-northeast1"
    tier             = "db-f1-micro"
  }
}
