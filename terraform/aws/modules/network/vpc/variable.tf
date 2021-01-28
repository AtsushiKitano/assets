variable "config" {
  type = object({
    vpc = object({
      name = string
      cidr = string
    })

    subnets = list(object({
      name = string
      cidr = string
      az   = string
    }))
  })
}

/*
  Option Values
*/

variable "public" {
  type    = bool
  default = true
}

variable "igw_enabled" {
  type    = bool
  default = true
}

variable "vpc_tags" {
  type    = map(string)
  default = null
}

variable "subnet_tags" {
  type    = map(map(string))
  default = {}
}

variable "ig_tags" {
  type    = map(string)
  default = null
}

variable "igw_tags" {
  type    = map(string)
  default = null
}
