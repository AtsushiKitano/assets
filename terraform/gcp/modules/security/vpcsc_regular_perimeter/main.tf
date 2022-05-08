resource "google_access_context_manager_service_perimeter" "main" {
  parent = format("accessPolicies/%s", var.parent)
  name   = format("accessPolicies/%s/servicePerimeters/%s", var.parent, var.title)
  title  = var.title

  perimeter_type = "PERIMETER_TYPE_REGULAR"

  status {
    restricted_services = var.restricted_services
    access_levels       = var.access_levels

    vpc_accessible_services {
      enable_restriction = var.enabled_vpc_accessible
      allowed_services   = var.allowed_services
    }

    dynamic "ingress_policies" {
      for_each = var.ingress_policies
      iterator = _conf

      content {
        ingress_from {
          identity_type = _conf.value.from.identity_type
          identities    = _conf.value.from.identities

          dynamic "sources" {
            for_each = _conf.value.ingress_from.access_levels
            iterator = _var

            content {
              access_level = _var.value
            }
          }

          dynamic "sources" {
            for_each = _conf.value.ingress_from.resource
            iterator = _var

            content {
              resource = _var.value
            }
          }

        }

        ingress_to {
          resources = _conf.value.to.resources

          dynamic "operations" {
            for_each = _conf.value.to.operations
            iterator = _var

            content {
              service_name = _var.value.service_name
              dynamic "method_selectors" {
                for_each = _var.value.method_selectors
                iterator = _args

                content {
                  method     = _args.value.method
                  permission = _args.value.permission
                }
              }
            }
          }
        }
      }
    }

    dynamic "egress_policies" {
      for_each = var.egress_policies
      iterator = _conf

      content {
        egress_from {
          identity_type = _conf.value.from.identity_type
          identities    = _conf.value.from.identities
        }

        egress_to {
          resources = _conf.value.to.resources

          dynamic "operations" {
            for_each = _conf.value.to.operations
            iterator = _var

            content {
              service_name = _var.value.service_name
              dynamic "method_selectors" {
                for_each = _var.value.method_selectors
                iterator = _args

                content {
                  method     = _args.value.method
                  permission = _args.value.permission
                }
              }
            }
          }
        }
      }
    }

  }
}

data "google_project" "main" {
  for_each = toset(var.projects)

  project_id = each.value
}

resource "google_access_context_manager_service_perimeter_resource" "main" {
  for_each = toset(var.projects)

  perimeter_name = google_access_context_manager_service_perimeter.main.name
  resource       = format("projects/%s", data.google_project.main[each.value].number)
}
