locals {
  _service_account_list = compact(distinct(flatten([
    for _conf in var.cron_job_conf : lookup(_conf.function_conf.opt_var, "service_account", "")
  ])))
}

data "google_service_account" "main" {
  for_each = toset(local._service_account_list)

  account_id = each.value
}
