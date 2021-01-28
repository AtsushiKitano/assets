locals {
  _pj_list = length(var.service_perimeters) > 0 ? distinct(flatten([
    for v in var.service_perimeters : v.status.resources
  ])) : []

  _gcp_service_pj_list = length(var.access_levels) > 0 ? flatten([
    for v in var.access_levels : [
      for w in v.basic.conditions : [
        for conf in w.members : conf.type != "member" && conf.type != "serviceAccount" && conf.type != "system" ? [
          conf.member
        ] : []
      ]
    ]
  ]) : []

  _service_accounts = distinct(flatten([
    for v in local._service_account_list : v.member != "not_service_account" ? [v] : []
  ]))

  pj_list = distinct(concat(local._pj_list, local._gcp_service_pj_list))
}

data "google_project" "main" {
  for_each = toset(local.pj_list)

  project_id = each.value
}

data "google_service_account" "main" {
  for_each = { for v in local._service_accounts : v.member => v }

  account_id = each.value.member
  project    = each.value.project
}
