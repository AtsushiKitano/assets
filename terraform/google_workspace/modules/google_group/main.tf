resource "googleworkspace_group" "main" {
  email       = var.email
  name        = var.name
  description = var.description

  aliases = var.aliases

  dynamic "timeouts" {
    for_each = var.timeouts != null ? ["dummy"] : []

    content {
      create = var.timeouts.create
      update = var.timeouts.update
    }
  }
}

resource "googleworkspace_group_member" "manager" {
  for_each = { for v in var.members : v.email => v }

  group_id = googleworkspace_group.main.id
  email    = each.value.email

  role = each.value.role
}
