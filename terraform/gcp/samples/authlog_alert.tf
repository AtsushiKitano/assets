locals {
  authlog_alert_sample_enabled = false

  _authlog_alert_sample_conf = local.authlog_alert_sample_enabled ? [
    {
      name = "sample"
    }
  ] : []
}

module "authlog_alert_sample" {
  for_each = { for v in local._authlog_alert_sample_conf : v.name => v }
  source   = "../modules/operation/alert/authlog_alert"

  conf = {
    display_name = each.value.name
    combiner     = "OR"
  }

  conditions = [
    {
      absent       = false
      duration     = "60s"
      name         = null
      display_name = each.value.name
      filter       = "metric.type=\"compute.googleapis.com/instance/disk/write_bytes_count\" AND resource.type=\"gce_instance\""

      trigger = {
        type  = "count"
        value = 1
      }

      aggregations = {
        per_series_aligner   = "ALIGN_RATE"
        alignment_period     = "60s"
        cross_series_reducer = null
        group_by_fields      = []
      }

      condition_threshold = {
        comparison      = "COMPARISON_GT"
        threshold_value = "1"
      }
    }
  ]
}
