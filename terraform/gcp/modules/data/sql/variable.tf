variable "sql_instance" {
  type = object({
    name             = string
    database_version = string
    region           = string
    tier             = string
  })
}

variable "database" {
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = []
}

variable "backup_configuration" {
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    start_time                     = string
    point_in_time_recovery_enabled = bool
  })
  default = null
}

variable "root_password" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "activation_policy" {
  type    = string
  default = null
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "disk_autoresize" {
  type    = bool
  default = true
}

variable "disk_size" {
  type    = number
  default = null
}

variable "disk_type" {
  type    = string
  default = "PD_HDD"
}

variable "pricing_plan" {
  type    = string
  default = null
}

variable "replication_type" {
  type    = string
  default = null
}

variable "flags" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "backup_conf" {
  type = object({
    binary_log_enabled             = bool
    enabled                        = bool
    start_time                     = string
    point_in_time_recovery_enabled = bool
  })
  default = null
}

variable "ip_configuration" {
  type = object({
    ipv4_enabled    = bool
    private_network = string
    require_ssl     = bool
  })
  default = null
}

variable "authorized_networks" {
  type = list(object({
    expiration_time = string
    name            = string
    value           = string
  }))
  default = []
}

variable "location_preference" {
  type = object({
    follow_gae_application = string
    zone                   = string
  })
  default = null
}

variable "maintenance" {
  type = object({
    day          = string
    hour         = string
    update_track = string
  })
  default = null
}

variable "replica_configuration" {
  type = object({
    dump_file_path          = string
    failover_target         = string
    master_heartbeat_period = string
    connect_retry_interval  = number
    username                = string
    password                = string
  })
  default = null
}

variable "sslcipher" {
  type    = string
  default = null
}

variable "verify_server_certificate" {
  type    = string
  default = null
}

variable "client_key" {
  type    = string
  default = null
}

variable "client_certificate" {
  type    = string
  default = null
}

variable "ca_certificate" {
  type    = string
  default = null
}
