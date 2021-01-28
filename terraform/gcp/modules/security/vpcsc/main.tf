locals {
  _users_list = length(var.access_levels) > 0 ? distinct(flatten([
    for v in var.access_levels : [
      for w in v.basic.conditions : [
        for conf in w.members : conf.type == "user" ? conf : {
          member = "not_user"
          type   = "not_user"
        }
      ]
    ]
  ])) : []

  _service_account_list = length(var.access_levels) > 0 ? distinct(flatten([
    for v in var.access_levels : [
      for w in v.basic.conditions : [
        for conf in w.members : conf.type == "serviceAccount" ? conf : {
          member  = "not_service_account"
          type    = "not_service_account"
          project = "not_service_account"
        }
      ]
    ]
  ])) : []

  _gcp_service_list = length(var.access_levels) > 0 ? distinct(flatten([
    for v in var.access_levels : [
      for w in v.basic.conditions : [
        for conf in w.members : conf.type != "user" && conf.type != "serviceAccount" && conf.type != "system" && conf.type != "logbase" ? conf : {
          member = "not_gcp_service"
          type   = "not_gcp_service"
        }
      ]
    ]
  ])) : []

  _system_list = length(var.access_levels) > 0 ? distinct(flatten([
    for v in var.access_levels : [
      for w in v.basic.conditions : [
        for conf in w.members : conf.type == "system" ? conf : {
          member = "not_gcp_service"
          type   = "serviceAccount"
        }
      ]
    ]
  ])) : []

  _log_base_list = length(var.access_levels) > 0 ? distinct(flatten([
    for v in var.access_levels : [
      for w in v.basic.conditions : [
        for conf in w.members : conf.type == "logbase" ? conf : {
          member = "not_logbase"
          type   = "not_logbase"
        }
      ]
    ]
  ])) : []
}

resource "google_access_context_manager_access_policy" "main" {
  parent = join("/", ["organizations", var.access_policy.parent])
  title  = var.access_policy.title
}

resource "google_access_context_manager_service_perimeter" "main" {
  for_each = { for v in var.service_perimeters : v.title => v }
  parent   = join("/", ["accessPolicies", google_access_context_manager_access_policy.main.name])


  name = join("/", [
    "accessPolicies", google_access_context_manager_access_policy.main.name,
    "servicePerimeters", each.value.title
  ])
  title          = each.value.title
  perimeter_type = each.value.perimeter_type

  dynamic "status" {
    for_each = each.value.status != null ? [each.value.status] : []
    content {
      access_levels = [
        for v in status.value.access_levels : google_access_context_manager_access_level.main[v].name
      ]
      restricted_services = status.value.restricted_services
      resources = [
        for v in status.value.resources : join("/", ["projects", data.google_project.main[v].number])
      ]

      dynamic "vpc_accessible_services" {
        for_each = status.value.vpc_accessible_services
        iterator = conf

        content {
          enable_restriction = conf.value.enable_restriction
          allowed_services   = conf.value.allowed_services
        }
      }
    }
  }
}

resource "google_access_context_manager_access_level" "main" {
  for_each = { for v in var.access_levels : v.name => v }

  parent = join("/", ["accessPolicies", google_access_context_manager_access_policy.main.name])
  title  = each.value.name
  name = join("/", [
    "accessPolicies", google_access_context_manager_access_policy.main.name,
    "accessLevels", each.value.name
  ])

  dynamic "basic" {
    for_each = each.value.basic != null ? ["enable"] : []

    content {
      combining_function = each.value.basic.combining_function
      dynamic "conditions" {
        for_each = each.value.basic.conditions
        iterator = conf

        content {
          ip_subnetworks         = conf.value.ip_subnetworks
          required_access_levels = conf.value.required_access_levels
          members = concat(compact(flatten([
            for v in conf.value.members : [
              for w in local._gcp_service_list : w.member == v.member ? join("", [
                "serviceAccount:", data.google_project.main[w.member].number,
                "@", v.type, ".gserviceaccount.com"
              ]) : ""
            ]
            ])), compact(flatten([
            for v in conf.value.members : [
              for w in local._users_list : w.member == v.member ? join(":", [
                v.type, v.member
              ]) : ""
            ]
            ])), compact(flatten([
            for v in conf.value.members : [
              for w in local._service_account_list : w.member == v.member ? join(":", [
                v.type, data.google_service_account.main[v.member].email
              ]) : ""
            ]
            ])), compact(flatten([
            for v in conf.value.members : [
              for w in local._system_list : w.member == v.member ? join(":", [
                "serviceAccount", v.member
              ]) : ""
            ]
            ])), compact(flatten([
            for v in conf.value.members : [
              for w in local._log_base_list : w.member == v.member ? join(":", [
                "serviceAccount", v.member
              ]) : ""
            ]
            ]))
          )
          regions = conf.value.regions
        }
      }
    }
  }
}
