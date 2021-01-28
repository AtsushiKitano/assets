variable "cluster" {
  type = object({
    name                      = string
    location                  = string
    cluster_ipv4_cidr         = string
    default_max_pods_per_node = number
    networking_mode           = string
    network                   = string
    subnetwork                = string
    master_ipv4_cidr_block    = string
  })
}

variable "master_authorized_networks_config" {
  type = list(object({
    display_name = string
    cidr_block   = string
  }))
  default = []
}

variable "node_pool" {
  type = list(object({
    name               = string
    location           = string
    initial_node_count = number
    node_locations     = list(string)
    disk_size_gb       = number
    disk_type          = string
    image_type         = string
    machine_type       = string
    tags               = list(string)
  }))
}

variable "node_pool_autoscaling" {
  type = map(object({
    min_node_count = number
    max_node_count = number
  }))
  default = null
}

variable "node_pool_upgrade" {
  type = map(object({
    max_surge       = number
    max_unavailable = number
  }))
  default = null
}

variable "node_pool_oauth_scopes" {
  type    = map(list(string))
  default = null
}

variable "cluster_autoscaling" {
  type = object({
    enabled = string
    resource_limits = object({
      resource_type = string
      minimum       = number
      maximum       = number
    })
    auto_provisioning_defaults = object({
      min_cpu_platform = string
      oauth_scopes     = list(string)
      service_account  = string
    })
  })
  default = null
}

variable "node_count" {
  type    = number
  default = null
}

variable "node_pool_max_pods" {
  type    = number
  default = null
}

variable "name_prefix" {
  type    = map(string)
  default = null
}

variable "pod_security_policy_config" {
  type    = bool
  default = false
}

variable "node_version" {
  type    = map(string)
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "service_account" {
  type = string
}

variable "workloadk_identity_id" {
  type    = string
  default = null
}

variable "remove_default_node_pool" {
  type    = bool
  default = true
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "management" {
  type = map(object({
    auto_repair  = bool
    auto_upgrade = bool
  }))
  default = null
}

variable "release_channel" {
  type    = string
  default = null
}

variable "identity_namespace" {
  type    = string
  default = null
}

variable "ip_ranges" {
  type = object({
    cluster  = string
    services = string
  })
  default = null
}

variable "private_endpoint" {
  type    = bool
  default = false
}

variable "private_nodes" {
  type    = bool
  default = true
}

variable "master_global_access_config" {
  type    = bool
  default = true
}

variable "preemptible" {
  type    = map(bool)
  default = null
}
