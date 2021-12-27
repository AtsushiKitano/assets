locals {
  _pj_iam_configs = flatten([
    for v in var.project_iam_roles : [
      for w in v.roles : {
        project = v.project
        role    = w
      }
    ]
  ])

  _folder_iam_configs = flatten([
    for v in var.folder_iam_roles : [
      for w in v.roles : {
        folder = v.folder_id
        role   = w
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

resource "google_organization_iam_member" "main" {
  for_each = toset(var.organization_iam_roles)

  org_id = var.org_id
  role   = each.value
  member = "serviceAccount:${var.service_account}"
}

resource "google_folder_iam_member" "main" {
  for_each = { for v in local._folder_iam_configs : "${v.folder}/${v.role}" => v }

  folder = "folders/${each.value.folder}"
  role   = each.value.role
  member = "serviceAccount:${var.service_account}"
}
