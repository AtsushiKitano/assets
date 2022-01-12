variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "routes" {
  type = list(object({
    dest_cidr   = string
    gwid        = string
    instance_id = string
    nat_gw      = string
  }))
}

variable "subnet_id" {
  type = list(string)
}

/*
Config Options
*/

variable "route_table_tags" {
  type    = map(string)
  default = null
}
