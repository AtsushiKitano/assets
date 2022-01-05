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

/*
  Option Values
*/

variable "public" {
  type    = bool
  default = true
}
