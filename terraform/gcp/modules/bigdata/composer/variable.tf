variable "config" {
  type = object({
    name         = string
    node_count   = number
    machine_type = string
    network      = string
    subnetwork   = string
  })
}

/*
Option Config
*/
variable "software_config" {
  type = object({
    airflow_config_overrides = map(string)
    pypi_packages            = map(string)
    env_variables            = map(string)
    image_version            = string
    python_version           = string
  })
  default = null
}


variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "zone" {
  type    = string
  default = "asia-northeast1-b"
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "disk_size_gb" {
  type    = number
  default = 20
}

variable "oauth_scopes" {
  type    = list(string)
  default = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "service_account" {
  type    = string
  default = null
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "project" {
  type    = string
  default = null
}

variable "database_config" {
  type = object({
    machine_type = string
  })
  default = null
}
