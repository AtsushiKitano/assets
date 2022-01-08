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

variable "key" {
  type = object({
    name       = string
    public_key = string
  })
  default = null
}

variable "interfaces" {
  type = list(object({
    name         = string
    subnet_id    = string
    private_ips  = list(string)
    tags         = map(string)
    device_index = number
  }))
  default = []
}

variable "private_ip" {
  type    = string
  default = null
}
