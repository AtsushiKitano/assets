locals {
  logbase_alert_enabled = false

  _logbase_alert_conf = local.logbase_alert_enabled ? [
    {
      name = "sample"
    }
  ] : []
}

module "logbase_alert_sample" {
  for_each = { for v in local._logbase_alert_conf : v.name => v }
  source   = "../modules/operation/alert/logbase_metric"

  conf = {
    metric_name   = each.value.name
    alert_name    = each.value.name
    display_name  = each.value.name
    resource_type = "gae_app"
    combiner      = "AND"
    filter        = "resource.type=gae_app AND severity>=ERROR"
    metric_descriptor = {
      value_type  = "INT64"
      metric_kind = "DELTA"
    }
  }

  conditions = [
    {
      name         = null
      display_name = each.value.name
      absent       = false
      duration     = "60s"
      trigger = {
        type  = "count"
        value = 1
      }

      aggregations = {
        per_series_aligner   = "ALIGN_RATE"
        group_by_fields      = []
        alignment_period     = "60s"
        cross_series_reducer = null
      }

      condition_threshold = {
        comparison      = "COMPARISON_GT"
        threshold_value = "0.9"
      }
    }
  ]
}
