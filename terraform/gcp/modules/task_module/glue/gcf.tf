locals {
  event_type = {
    gcs_finalize        = "google.storage.object.finalize"
    gcs_delete          = "google.storage.object.delete"
    gcs_arcive          = "google.storage.object.archive"
    gcs_metadata_update = "google.storage.object.metadataUpdate"
    pubsub              = "google.pubsub.topic.publish"
  }
}

resource "google_cloudfunctions_function" "main" {
  name    = var.conf.name
  runtime = var.conf.runtime
  region  = var.conf.region

  environment_variables = var.conf.environment_variables

  description         = lookup(var.conf.opt_var, "description", null)
  available_memory_mb = lookup(var.conf.opt_var, "available_memory_mb", 256)
  timeout             = lookup(var.conf.opt_var, "timeout", 540)
  entry_point         = lookup(var.conf.opt_var, "entry_point", null)

  dynamic "event_trigger" {
    for_each = lookup(var.conf.opt_var, "event_trigger", false) ? [{
      resource_type  = lookup(var.conf.opt_var, "resource_type", null)
      resource       = lookup(var.conf.opt_var, "resource", null)
      failure_policy = lookup(var.conf.opt_var, "failure_policy", false)
      retry          = lookup(var.conf.opt_var, "retry", false)
    }] : []
    content {
      event_type = local.event_type[event_trigger.value.resource_type]
      resource   = event_trigger.value.resource_type == "pubsub" ? google_pubsub_topic.main[event_trigger.value.resource].id : google_storage_bucket.main[event_trigger.value.resource].name
      dynamic "failure_policy" {
        for_each = event_trigger.value.failure_policy ? [{
          retry = event_trigger.value.retry
        }] : []
        content {
          retry = failure_policy.value.retry
        }
      }
    }
  }

  trigger_http                  = lookup(var.conf.opt_var, "trigger_http", null)
  ingress_settings              = lookup(var.conf.opt_var, "ingress_settings", null)
  service_account_email         = lookup(var.conf.opt_var, "service_account_email", null) != null ? data.google_service_account.main[lookup(var.conf.opt_var, "service_account_email", null)].email : null
  vpc_connector                 = lookup(var.conf.opt_var, "vpc_connector", null)
  vpc_connector_egress_settings = lookup(var.conf.opt_var, "vpc_connector_egress_settings", null)
  source_archive_bucket         = lookup(var.conf.opt_var, "source_archive_bucket", null)
  source_archive_object         = lookup(var.conf.opt_var, "source_archive_object", null)
  max_instances                 = lookup(var.conf.opt_var, "max_instances", null)

  dynamic "source_repository" {
    for_each = lookup(var.conf.opt_var, "source_repository", false) ? [{
      url = lookup(var.conf.opt_var, "url", null)
    }] : []
    content {
      url = source_repository.value.url
    }
  }
}
