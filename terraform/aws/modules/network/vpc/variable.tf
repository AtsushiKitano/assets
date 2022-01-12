variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = list(object({
    name = string
    cidr = string
    az   = string
  }))

  default = []
}

variable "security_group" {
  type = object({
    name = string
    tags = map(string)
    rules = list(object({
      type        = string
      cidr_blocks = list(string)
      from_port   = string
      to_port     = string
      protocol    = string
    }))
  })
  default = null
}

/*
  Option Values
*/

variable "public" {
  type    = bool
  default = true
}

variable "route_config" {
  type = object({
    name = string
    routes = list(object({
      dest_cidr   = string
      gwid        = string
      instance_id = string
      nat_gw      = string
    }))
    subnets = list(string)
  })
  default = null
}
