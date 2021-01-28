locals {
  _service_account_iam = [
    for v in var.service_account.roles : {
      name = var.service_account.name
      role = join("/", ["roles", v])
    }
  ]
}

resource "google_service_account" "main" {
  account_id   = var.service_account.name
  display_name = var.display_name
  description  = var.description
  project      = var.project
}

resource "google_project_iam_member" "main" {
  for_each = { for v in local._service_account_iam : join("_", [v.name, v.role]) => v }

  member  = join(":", ["serviceAccount", google_service_account.main.email])
  role    = each.value.role
  project = var.project

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []
    iterator = _conf

    content {
      expression = _conf.value.expression
      title      = _conf.value.title
    }
  }
}
