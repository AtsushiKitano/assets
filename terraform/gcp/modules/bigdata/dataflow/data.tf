locals {
  _service_account_list = distinct(flatten([
    for _conf in var.dataflow_conf : [
      for _dataflow_conf in _conf.job_conf : _dataflow_conf.service_account_email
    ] if _conf.enable
  ]))

  _network_list = distinct(flatten([
    for _conf in var.dataflow_conf : [
      for _dataflow_conf in _conf.job_conf : _dataflow_conf.network
    ] if _conf.enable
  ]))

  _subnetwork_list = distinct(flatten([
    for _conf in var.dataflow_conf : [
      for _dataflow_conf in _conf.job_conf : {
        name   = _dataflow_conf.subnetwork
        region = _dataflow_conf.region
      }
    ] if _conf.enable
  ]))
}

data "google_service_account" "main" {
  for_each = toset(local._service_account_list)

  account_id = each.value
}

data "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnetwork_list : v.name => v }

  name   = each.value.name
  region = each.value.region
}

data "google_compute_network" "main" {
  for_each = toset(local._network_list)

  name = each.value
}
