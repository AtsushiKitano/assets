locals {
  _service_account_list = compact(distinct(flatten([
    for _conf in var.glue_conf : lookup(_conf.gcf_conf.opt_var, "service_account_email", "") if _conf.enable
  ])))
}

data "google_service_account" "main" {
  for_each = toset(local._service_account_list)

  account_id = each.value
}
