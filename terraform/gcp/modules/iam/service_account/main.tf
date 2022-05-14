resource "google_service_account" "main" {
  account_id   = var.name
  display_name = var.display_name
  description  = var.description
  project      = var.project
}

resource "google_project_iam_member" "main" {
  for_each = toset(var.roles)

  member  = join(":", ["serviceAccount", google_service_account.main.email])
  role    = each.value
  project = var.project

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []

    content {
      expression = var.condition.expression
      title      = var.condition.title
    }
  }
}
