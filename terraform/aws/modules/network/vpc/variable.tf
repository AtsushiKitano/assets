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
    tags = map(string)
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

variable "vpc_tags" {
  type    = map(string)
  default = null
}

variable "igw_tags" {
  type    = map(string)
  default = null
}
