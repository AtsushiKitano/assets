variable "config" {
  type = object({
    name = string
    az   = string
    instance = object({
      instance_type   = string
      subnet_id       = string
      security_groups = list(string)
    })
  })
}

/*
Option Configs
*/
variable "instance_tags" {
  type    = map(string)
  default = {}
}

variable "ami_owners" {
  type    = list(string)
  default = ["amazon"]
}

variable "ami_filters" {
  type = map(string)
  default = {
    "architecture"                     = ["x86_64"]
    "root-device-type"                 = ["ebs"]
    "name"                             = ["ubuntu-*"]
    "virtualization-type"              = ["hvm"]
    "block-device-mapping.volume-type" = ["gp2"]
  }
}
