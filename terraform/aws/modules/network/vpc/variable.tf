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

variable "security_groups" {
  type = object({
    name = string
    tags = map(string)
    rules = list(object({
      type        = string
      cidr_blocks = string
      from_port   = string
      to_port     = string
      protocol    = string
    }))
  })
  default = {}
}

/*
  Option Values
*/

variable "public" {
  type    = bool
  default = true
}
