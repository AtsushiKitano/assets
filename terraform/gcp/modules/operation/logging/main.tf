locals {
  destination = {
    bq         = format("bigquery.googleapis.com/projects/%s/datasets/%s-log-sink", local._sink_dst_pj, var.name)
    pubsub     = format("pubsub.googleapis.com/projects/%s/topics/%s-log-sink", local._sink_dst_pj, var.name)
    log_bucket = format("logging.googleapis.com/projects/%s/locations/global/buckets/%s-log-sink", local._sink_dst_pj, var.name)
    gcs        = format("storage.googleapis.com/%s-%s-log-sink", local._sink_dst_pj, var.name)
  }

  _sink_dst_pj = var.dest_pj != null ? var.dest_pj : var.project
}


resource "google_logging_project_sink" "main" {
  depends_on = [
    google_storage_bucket.main.*,
    google_pubsub_topic.main.*,
    google_bigquery_Dataset.main.*
  ]
  name        = var.name
  filter      = var.filter
  project     = var.project
  destination = local.destination[var.type]

  unique_writer_identity = var.unique_writer_identity
}

resource "google_storage_bucket" "main" {
  for_each = var.type == "gcs" ? toset(["enable"]) : []

  name          = format("%s-%s-log-sink", local._sink_dst_pj, var.name)
  project       = local._sink_dst_pj
  storage_class = var.storage_class
}

resource "google_pubsub_topic" "main" {
  for_each                   = var.type == "pubsub" ? toset(["enable"]) : []
  name                       = format("%s-log-sink", var.name)
  message_retention_duration = var.message_retention_duration
}

resource "google_bigquery_dataset" "main" {
  for_each                    = var.type == "bq" ? toset(["enable"]) : []
  friendly_name               = format("%s-log-sink", var.name)
  location                    = var.location
  default_table_expiration_ms = var.default_table_expiration_ms
}
