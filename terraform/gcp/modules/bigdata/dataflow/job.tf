locals {
  _job_conf = flatten([
    for _conf in var.dataflow_conf : _conf.job_conf if _conf.enable
  ])
}

resource "google_dataflow_job" "main" {
  for_each = { for v in local._job_conf : v.name => v }

  name                  = each.value.name
  template_gcs_path     = each.value.template_gcs_path
  temp_gcs_location     = each.value.temp_gcs_location
  network               = each.value.network
  subnetwork            = each.value.subnetwork
  machine_type          = each.value.machine_type
  zone                  = each.value.zone
  region                = each.value.region
  service_account_email = data.google_service_account.main[each.value.service_account_email].email
  ip_configuration      = lookup(each.value.opt_conf, "ip_configuration", "WORKER_IP_PUBLIC")
  on_delete             = lookup(each.value.opt_conf, "on_delete", "cancel")
  parameters            = each.value.params

}
