locals {
  _pubsub_topic_conf = flatten([
    for _conf in var.cron_job_conf : _conf.pubsub_topic_conf if _conf.enable
  ])
}

resource "google_pubsub_topic" "main" {
  for_each = { for v in local._pubsub_topic_conf : v.name => v }
  depends_on = [
    google_project_service.main["pubsub"]
  ]

  name         = each.value.name
  kms_key_name = lookup(each.value.opt_var, "kms_key_name", null)
}
