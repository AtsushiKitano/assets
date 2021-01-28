variable "vpc_id" {
  type = string
}

variable "sg" {
  type = object({
    name = string
    rules = list(object({
      type        = string
      cidr_blocks = list(string)
      from_port   = number
      to_port     = number
      protocol    = string
    }))
  })
}

variable "ncl" {
  type = object({
    name       = string
    subnet_ids = list(string)
    rules = list(object({
      rule_number = number
      egress      = bool
      protocol    = string
      rule_action = string
      cidr        = string
      from_port   = number
      to_port     = number
      icmp_type   = string
      icmp_code   = string
    }))
  })
}

/*
Config Options
*/
variable "sg_tags" {
  type    = map(string)
  default = {}
}

variable "ncl_tags" {
  type    = map(string)
  default = {}
}
