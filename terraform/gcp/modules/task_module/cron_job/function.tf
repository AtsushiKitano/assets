locals {
  _function_conf = flatten([
    for _conf in var.cron_job_conf : {
      region          = _conf.region
      url             = _conf.function_conf.url
      name            = _conf.function_conf.name
      runtime         = _conf.function_conf.runtime
      entry_point     = _conf.function_conf.entry_point
      opt_var         = _conf.function_conf.opt_var
      pubsub_topic    = _conf.pubsub_topic_conf.name
      service_account = lookup(_conf.function_conf.opt_var, "service_account", null)
    } if _conf.enable
  ])
}

resource "google_cloudfunctions_function" "main" {
  for_each = { for v in local._function_conf : v.name => v }

  depends_on = [
    google_project_service.main["cloudfunctions"],
  ]

  name        = each.value.name
  runtime     = each.value.runtime
  region      = each.value.region
  entry_point = each.value.entry_point

  timeout               = lookup(each.value.opt_var, "timeout", null)
  description           = lookup(each.value.opt_var, "description", null)
  available_memory_mb   = lookup(each.value.opt_var, "available_memory_mb", null)
  service_account_email = each.value.service_account != null ? data.google_service_account.main[each.value.service_account].email : null

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.main[each.value.pubsub_topic].id

    dynamic "failure_policy" {
      for_each = lookup(each.value.opt_var, "failure_policy", false) ? [{
        retry = lookup(each.value.opt_var, "retry", false)
      }] : []
      content {
        retry = failure_policy.value.retry
      }
    }
  }

  source_repository {
    url = each.value.url
  }
}
