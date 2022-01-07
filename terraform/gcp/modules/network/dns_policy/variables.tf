variable "name" {
  type = string
}

variable "networks" {
  type = list(string)
}

/*
Option Config
*/

variable "enable_inbound_forwarding" {
  type    = bool
  default = false
}

variable "enable_logging" {
  type    = bool
  default = false
}

variable "target_name_servers" {
  type = list(object({
    ipv4_address    = string
    forwarding_path = string
  }))
  default = []
}
