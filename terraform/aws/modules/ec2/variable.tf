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
  type = list(object({
    name   = string
    values = list(string)
  }))

  default = [
    {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    },
    {
      name   = "virtualization-type"
      values = ["hvm"]
    }
  ]
}
