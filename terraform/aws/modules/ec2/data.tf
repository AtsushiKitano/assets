data "aws_ami" "main" {
  most_recent = true
  owners      = var.ami_owners

  dynamic "filter" {
    for_each = var.ami_filters
    iterator = _conf

    content {
      name   = _conf.value.name
      values = _conf.value.values
    }
  }
}
