locals {
  destination = {
    bq         = format("bigquery.googleapis.com/projects/%s/datasets/%s", local._sink_dst_pj, local._bq_dataset_id)
    pubsub     = format("pubsub.googleapis.com/projects/%s/topics/%s-log-sink", local._sink_dst_pj, var.name)
    log_bucket = format("logging.googleapis.com/projects/%s/locations/global/buckets/%s-log-sink", local._sink_dst_pj, var.name)
    gcs        = format("storage.googleapis.com/%s-%s-log-sink", local._sink_dst_pj, var.name)
  }

  _sink_dst_pj   = var.dest_pj != null ? var.dest_pj : var.project
  _bq_dataset_id = replace(format("%s-log-sink", var.name), "-", "_")
}


resource "google_logging_project_sink" "main" {
  depends_on = [
    google_storage_bucket.main,
    google_pubsub_topic.main,
    google_bigquery_dataset.main
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
  location      = var.location
}

resource "google_logging_project_bucket_config" "main" {
  for_each = var.type == "log_bucket" ? toset(["enable"]) : []

  location       = var.log_bucket.location
  retention_days = var.log_bucket.retention_days
  bucket_id      = format("%s-log-sink", var.name)
  project        = local._sink_dst_pj
}

resource "google_pubsub_topic" "main" {
  for_each                   = var.type == "pubsub" ? toset(["enable"]) : []
  project                    = local._sink_dst_pj
  name                       = format("%s-log-sink", var.name)
  message_retention_duration = var.message_retention_duration
}

resource "google_bigquery_dataset" "main" {
  for_each                    = var.type == "bq" ? toset(["enable"]) : []
  project                     = local._sink_dst_pj
  dataset_id                  = local._bq_dataset_id
  location                    = var.location
  default_table_expiration_ms = var.default_table_expiration_ms
}

resource "google_storage_bucket_iam_member" "main" {
  for_each = var.type == "gcs" ? toset(["enable"]) : []
  bucket   = google_storage_bucket.main["enable"].name
  role     = "roles/storage.objectCreator"
  member   = google_logging_project_sink.main.writer_identity
}

resource "google_bigquery_dataset_iam_member" "main" {
  for_each   = var.type == "bq" ? toset(["enable"]) : []
  project    = local._sink_dst_pj
  dataset_id = google_bigquery_dataset.main["enable"].dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.main.writer_identity
}

resource "google_pubsub_topic_iam_member" "main" {
  for_each = var.type == "pubsub" ? toset(["enable"]) : []
  project  = local._sink_dst_pj
  topic    = google_pubsub_topic.main["enable"].name
  role     = "roles/pubsub.publisher"
  member   = google_logging_project_sink.main.writer_identity
}

resource "google_project_iam_member" "main" {
  for_each = var.type == "log_bucket" && var.dest_pj != null ? toset(["enable"]) : []
  project  = local._sink_dst_pj
  member   = google_logging_project_sink.main.writer_identity
  role     = "roles/logging.bucketWriter"
}
