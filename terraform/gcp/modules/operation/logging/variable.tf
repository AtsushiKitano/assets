variable "type" {
  type = string
  validation {
    condition     = var.type == "gcs" || var.type == "bq" || var.type == "pubsub" || var.type == "log_bucket"
    error_message = "type valiable must be gcs,bq,pubsub or log_bucket"
  }
}

variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "filter" {
  type = string
}

/*
 Option
*/

variable "dest_pj" {
  type    = string
  default = null
}

variable "unique_writer_identity" {
  type    = bool
  default = false
}

variable "storage_class" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = var.storage_class == "STANDARD" || var.storage_class == "MULTI_REGIONAL" || var.storage_class == "REGIONAL" || var.storage_class == "NEARLINE" || var.storage_class == "COLDLINE" || var.storage_class == "ARCHIVE"
    error_message = "storage_class must be STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE"
  }
}

variable "message_retention_duration" {
  type    = string
  default = "60s"
}

variable "default_table_expiration_ms" {
  type    = number
  default = 3600
}

variable "location" {
  type    = string
  default = "asia-northeast1"
}
