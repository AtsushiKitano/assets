locals {
  _domain_conf = var.domain != null ? [var.domain] : []
}

resource "google_cloud_run_service" "main" {
  name                       = var.config.name
  project                    = var.project
  autogenerate_revision_name = var.autogenerate_revision_name
  location                   = var.config.location

  dynamic "traffic" {
    for_each = var.traffic != null ? [var.traffic] : []
    iterator = _conf

    content {
      revision_name = _conf.value.revision_name
      percent       = _conf.value.percent
    }
  }

  template {
    spec {
      container_concurrency = var.config.spec.container_concurrency
      timeout_seconds       = var.config.spec.timeout_seconds
      service_account_name  = var.service_account
      serving_state         = var.serving_state

      containers {
        args    = var.config.containers.args
        image   = var.config.containers.image
        command = var.config.containers.command

        dynamic "env_from" {
          for_each = var.env_from != null ? [var.env_from] : []
          iterator = _conf

          content {
            prefix = _conf.value.prefix

            dynamic "secret_ref" {
              for_each = var.secret_ref
              iterator = _param

              content {
                optional = _param.value.optional
                dynamic "local_object_reference" {
                  for_each = _param.value.local_object_reference != null ? [_param.value.local_object_reference] : []
                  iterator = _setting

                  content {
                    name = _setting.value.name
                  }
                }
              }
            }

            dynamic "config_map_ref" {
              for_each = var.config_map_ref
              iterator = _param

              content {
                optional = _param.value.optional
                dynamic "local_object_reference" {
                  for_each = _param.value.local_object_reference != null ? [_param.value.local_object_reference] : []
                  iterator = _setting

                  content {
                    name = _setting.name
                  }
                }
              }
            }
          }
        }

        dynamic "env" {
          for_each = var.env
          iterator = _conf

          content {
            name  = _conf.value.name
            value = _conf.value.value
          }
        }

        dynamic "ports" {
          for_each = var.ports
          iterator = _conf

          content {
            name           = _conf.value.name
            protocol       = _conf.value.protocol
            container_port = _conf.value.container_port
          }
        }

        dynamic "resources" {
          for_each = var.resources != null ? [var.resources] : []
          iterator = _conf

          content {
            limits   = _conf.value.limits
            requests = _conf.value.requests
          }
        }
      }
    }

    dynamic "metadata" {
      for_each = var.metadata != null ? [var.metadata] : []
      iterator = _conf

      content {
        labels           = _conf.value.labels
        generation       = _conf.value.generation
        resource_version = _conf.value.resource_version
        namespace        = var.project
        annotations      = var.annotations
        name             = _conf.value.name
      }
    }
  }
}

resource "google_cloud_run_domain_mapping" "main" {
  for_each = { for v in local._domain_conf : v.name => v }

  name     = each.value.name
  location = each.value.location
  project  = var.project

  spec {
    route_name       = google_cloud_run_service.main.name
    certificate_mode = var.domain_spec.certificate_mode
    force_override   = var.domain_spec.force_override
  }

  metadata {
    namespace        = var.project
    annotations      = var.domain_metadata.annotations
    labels           = var.domain_metadata.labels
    generation       = var.domain_metadata.generation
    resource_version = var.domain_metadata.resource_version
  }
}
