resource "google_monitoring_uptime_check_config" "main" {
  display_name     = var.conf.display_name
  timeout          = var.conf.timeout
  period           = var.conf.period
  project          = var.project
  selected_regions = var.regions

  dynamic "content_matchers" {
    for_each = var.content_matchers != null ? [var.content_matchers] : []
    iterator = _conf

    content {
      content = _conf.value.content
      matcher = _conf.value.matcher
    }
  }

  dynamic "http_check" {
    for_each = var.http_check != null ? [var.http_check] : []
    iterator = _conf

    content {
      request_method = _conf.value.request_method
      content_type   = _conf.value.content_type
      port           = _conf.value.port
      headers        = _conf.value.headers
      path           = _conf.value.path
      use_ssl        = _conf.value.use_ssl
      validate_ssl   = _conf.value.validate_ssl
      mask_headers   = _conf.value.mask_headers
      body           = _conf.value.body

      dynamic "auth_info" {
        for_each = var.auth_info != null && var.http_check != null ? [var.auth_info] : []
        iterator = _var

        content {
          password = _var.value.password
          username = _var.value.username
        }
      }

    }
  }

  dynamic "tcp_check" {
    for_each = var.tcp_check != null ? [var.tcp_check] : []
    iterator = _conf

    content {
      port = _conf.value.port
    }
  }

  dynamic "resource_group" {
    for_each = var.resource_group != null ? [var.resource_group] : []
    iterator = _conf

    content {
      resource_type = _conf.value.resource_type
      group_id      = _conf.value.group_id
    }
  }

  dynamic "monitored_resource" {
    for_each = var.monitored_resource != null ? [var.monitored_resource] : []
    iterator = _conf

    content {
      type   = _conf.value.type
      labels = _conf.value.labels
    }
  }

}

resource "google_monitoring_alert_policy" "main" {
  display_name          = var.conf.display_name
  combiner              = var.conf.combiner
  project               = var.project
  enabled               = var.enabled
  notification_channels = var.notification_channels

  dynamic "documentation" {
    for_each = var.document != null ? [var.document] : []
    iterator = _conf

    content {
      content   = _conf.value.content
      mime_type = _conf.value.mime_type
    }
  }

  dynamic "conditions" {
    for_each = var.conditions
    iterator = _conf

    content {
      name         = _conf.value.name
      display_name = _conf.value.display_name

      dynamic "condition_threshold" {
        for_each = _conf.value.condition_threshold != null ? [_conf.value.condition_threshold] : []
        iterator = _var

        content {
          duration   = _conf.value.duration
          comparison = _var.value.comparison
          filter = join(" ", [
            "metric.type=\"monitoring.googleapis.com/uptime_check/checked_passed\"",
            "resource.type=\"uptime_url\"",
            "metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.main.uptime_check_id}\""
          ])
          threshold_value = _var.value.threshold_value

          dynamic "trigger" {
            for_each = _conf.value.trigger.type == "percent" ? [_conf.value.trigger.value] : []
            iterator = _var

            content {
              percent = _var.value
            }
          }

          dynamic "trigger" {
            for_each = _conf.value.trigger.type == "count" ? [_conf.value.trigger.value] : []
            iterator = _val

            content {
              count = _val.value
            }
          }

          dynamic "aggregations" {
            for_each = _conf.value.aggregations != null ? [_conf.value.aggregations] : []
            iterator = _val

            content {
              per_series_aligner   = _val.value.per_series_aligner
              group_by_fields      = _val.value.group_by_fields
              alignment_period     = _val.value.alignment_period
              cross_series_reducer = _val.value.cross_series_reducer
            }
          }
        }
      }
    }
  }
}
