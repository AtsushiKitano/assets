locals {
  _scheduler_conf = flatten([
    for _conf in var.cron_job_conf : {
      name       = _conf.scheduler_job_conf.name
      schedule   = _conf.scheduler_job_conf.schedule
      time_zone  = _conf.scheduler_job_conf.time_zone
      data       = _conf.scheduler_job_conf.data
      opt_var    = _conf.scheduler_job_conf.opt_var
      topic_name = _conf.pubsub_topic_conf.name
      region     = _conf.region
    } if _conf.enable
  ])
}

resource "google_cloud_scheduler_job" "main" {
  for_each = { for v in local._scheduler_conf : v.name => v }

  depends_on = [
    google_project_service.main["cloudscheduler"],
    google_project_service.main["appengine"],
  ]

  name             = each.value.name
  region           = each.value.region
  time_zone        = each.value.time_zone
  schedule         = each.value.schedule
  description      = lookup(each.value.opt_var, "description", null)
  attempt_deadline = lookup(each.value.opt_var, "attempt_deadline", null)

  dynamic "retry_config" {
    for_each = lookup(each.value.opt_var, "retry_config", false) ? [{
      retry_count          = lookup(each.value.opt_var, "retry_count", null)
      max_doublings        = lookup(each.value.opt_var, "max_doublings", null)
      max_retry_duration   = lookup(each.value.opt_var, "max_retry_duration", null)
      min_backoff_duration = lookup(each.value.opt_var, "min_backoff_duration", null)
    }] : []
    content {
      retry_count          = retry_config.value.retry_count
      max_retry_duration   = retry_config.value.max_retry_duration
      min_backoff_duration = retry_config.value.min_backoff_duration
      max_doublings        = retry_config.value.max_doublings
    }
  }


  pubsub_target {
    topic_name = google_pubsub_topic.main[each.value.topic_name].id
    data       = lookup(each.value.opt_var, "data", null)
  }
}
