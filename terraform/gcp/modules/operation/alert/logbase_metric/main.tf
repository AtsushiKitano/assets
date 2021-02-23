resource "google_logging_metric" "main" {
  name    = var.conf.metric_name
  filter  = var.conf.filter
  project = var.project

  metric_descriptor {
    value_type  = var.conf.metric_descriptor.value_type
    metric_kind = var.conf.metric_descriptor.metric_kind
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
          duration        = _conf.value.duration
          comparison      = _var.value.comparison
          filter          = join(" ", ["metric.type=\"logging.googleapis.com/user/${google_logging_metric.main.id}\"", "resource.type=${var.conf.resource_type}"])
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
            for_each = _conf.value.aggregations != null && !_conf.value.absent ? [_conf.value.aggregations] : []
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

      dynamic "condition_absent" {
        for_each = _conf.value.absent ? ["enable"] : []

        content {
          duration = _conf.value.duration
          filter   = join(" ", ["metric.type=\"logging.googleapis.com/user/${google_logging_metric.main.id}\"", "resource.type=${var.conf.resource_type}"])

          dynamic "aggregations" {
            for_each = _conf.value.aggregations != null ? [_conf.value.aggregations] : []
            iterator = _var

            content {
              per_series_aligner   = _var.value.per_series_aligner
              group_by_fields      = _var.value.group_by_fields
              alignment_period     = _var.value.alignment_period
              cross_series_reducer = _var.value.cross_series_reducer
            }
          }

          dynamic "trigger" {
            for_each = _conf.value.trigger.type == "percent" ? [_conf.value.trigger.value] : []
            iterator = _var

            content {
              percent = _var.value
            }
          }

          dynamic "trigger" {
            for_each = _conf.value.trigger.type == "count" ? [_conf.value.trigger.value] : []
            iterator = _var

            content {
              count = _var.value
            }
          }
        }
      }
    }
  }
}
