/*
  Required arguments
*/
variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "environment_size" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "cluster_secondary_range_name" {
  type = string
}

variable "services_secondary_range_name" {
  type = string
}

variable "airflow_config_overrides" {
  type = map(string)
}

variable "image_version" {
  type = string

  validation {
    condition     = tonumber(split(".", split("-", var.image_version)[1])[0]) == 2
    error_message = "Composer Image Version Must be 2."
  }
}

variable "service_account_id" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "cloud_sql_ipv4_cidr_block" {
  type = string
}

variable "env_variables" {
  type = map(string)
}


variable "cloud_composer_network_ipv4_cidr_block" {
  type = string
}

/*
  Optional arguments
*/
variable "key_project" {
  type    = string
  default = null
}

variable "enable_cmek" {
  type    = bool
  default = true
}

variable "key_ring" {
  type    = string
  default = "cloud-composer"
}

variable "key_location" {
  type    = string
  default = null
}


variable "pypi_packages" {
  type    = map(string)
  default = null
}

variable "enable_private_endpoint" {
  type    = bool
  default = true
}

variable "labels" {
  type    = map(string)
  default = null
}


variable "allowd_ip_ranges" {
  type = list(object({
    ip_range    = string
    description = string
  }))
  default = []
}

variable "workload_config_enabled" {
  type    = bool
  default = true
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

variable "web_server" {
  type = object({
    cpu        = number
    memory_gb  = number
    storage_gb = number
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
