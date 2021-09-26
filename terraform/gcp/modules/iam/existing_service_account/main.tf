locals {
  _pj_iam_configs = flatten([
    for v in var.project_iam_roles : [
      for w in v.roles : {
        project = v.project
        role    = w
      }
    ]
  ])
}

resource "google_project_iam_member" "main" {
  for_each = { for v in local._pj_iam_configs : "${v.project}/${v.role}" => v }

  project = each.value.project
  member  = "serviceAccount:${var.service_account}"
  role    = each.value.role
}
