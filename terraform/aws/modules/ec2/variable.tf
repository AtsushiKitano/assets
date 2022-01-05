variable "instance_type" {
  type = string
}

variable "az" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "name" {
  type = string
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
  default = ["099720109477"]
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
