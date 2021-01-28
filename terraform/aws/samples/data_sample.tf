locals {
  filters = {
    architecture                       = ["x86_64"]
    root-device-type                   = ["ebs"]
    name                               = ["ubuntu-*"]
    virtualization-type                = ["hvm"]
    "block-device-mapping.volume-type" = ["gp2"]
  }
}

data "aws_ami" "main" {
  most_recent = true
  owners      = ["amazon"]

  dynamic "filter" {
    for_each = local.filters
    iterator = _conf

    content {
      name   = _conf.key
      values = _conf.value
    }
  }
}

output "ami" {
  value = data.aws_ami.main.id
}
