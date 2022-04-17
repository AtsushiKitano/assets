variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

/*
 Option Config
*/
variable "pypi_packages" {
  type    = map(string)
  default = null
}

variable "env_variables" {
  type    = map(string)
  default = null
}

variable "airflow_config_overrides" {
  type    = map(string)
  default = null
}

variable "enable_private_endpoint" {
  type    = bool
  default = false
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = null
}

variable "cloud_sql_ipv4_cidr_block" {
  type    = string
  default = null
}

variable "cloud_composer_network_ipv4_cidr_block" {
  type    = string
  default = null
}

variable "cloud_composer_connection_subnetwork" {
  type    = string
  default = null
}

variable "maintenance_window" {
  type = object({
    start_time = string
    end_time   = string
    recurrence = string
  })
  default = null
}

variable "worker" {
  type = object({
    cpu        = number
    memory_gb  = number
    storage_gb = number
    min_count  = number
    max_count  = number
  })
  default = null
}

variable "web_server" {
  type = object({
    cpu       = number
    memory_gb = number
    storge_gb = number
  })
  default = null
}

variable "scheduler" {
  type = object({
    cpu        = number
    memory_gb  = number
    storage_gb = number
    count      = number
  })
  default = null
}

variable "maintenance_window" {
  type = object({
    start_time = string
    end_time   = string
    recurrence = string
  })
  default = null
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "image_version" {
  type    = string
  default = "composer-2-airflow-2"
}

variable "environment_size" {
  type    = string
  default = "ENVIRONMENT_SIZE_SMALL"
}
