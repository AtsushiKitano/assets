variable "name" {
  type = string
}

variable "direction" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "ip_addresses" {
  type = list(object({
    subnet_id = string
    ip        = string
  }))
}


/*
Option Configs
*/
variable "tags" {
  type    = map(string)
  default = null
}

variable "resolver_rules" {
  type = list(object({
    name        = string
    domain_name = string
    rule_type   = string
    targets = list(object({
      ip   = string
      port = number
    }))
    tags = map(string)
  }))
  default = []
}

variable "associations" {
  type = list(object({
    rule_name = string
    networks  = list(string)
  }))
  default = []
}
