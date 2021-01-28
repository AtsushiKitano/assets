variable "config" {
  type = object({
    name   = string
    vpc_id = string

    routes = list(object({
      dest_cidr   = string
      gwid        = string
      instance_id = string
      nat_gw      = string
    }))
  })
}

/*
Config Options
*/

variable "assign_subnet" {
  type    = map(string)
  default = {}
}

variable "route_table_tags" {
  type    = map(string)
  default = null
}
