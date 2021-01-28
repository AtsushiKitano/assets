locals {
  _iam_infos = [
    for v in var.iam_conf.roles : {
      member = join(":", [var.iam_conf.member_type, var.iam_conf.email])
      role   = join("/", ["roles", v])
    }
  ]
}

resource "google_project_iam_member" "main" {
  for_each = { for v in local._iam_infos : join("_", [v.member, v.role]) => v }

  role    = each.value.role
  member  = each.value.member
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
