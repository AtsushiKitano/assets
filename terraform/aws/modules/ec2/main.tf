resource "aws_instance" "main" {
  ami               = data.aws_ami.main.id
  availability_zone = var.az
  instance_type     = var.instance_type
  security_groups   = var.security_groups
  subnet_id         = var.subnet_id
  key_name          = var.key != null ? aws_key_pair.main["enable"].key_name : null
  private_ip        = var.private_ip

  dynamic "network_interface" {
    for_each = var.interfaces
    iterator = _conf

    content {
      network_interface_id = aws_network_instance.main[_conf.value.name].id
      device_index         = _conf.value.device_index
    }
  }

  tags = merge({ "Name" = var.name }, var.instance_tags)
}

resource "aws_network_instance" "main" {
  for_each = { for v in var.interfaces : v.name => v }

  subnet_id   = each.value.subnet_id
  private_ips = each.value.private_ips
  tags        = merge({ Name = each.value.name }, each.value.tags)
}

resource "aws_key_pair" "main" {
  for_each = var.key != null ? toset(["enable"]) : []

  key_name   = var.key.name
  public_key = var.key.public_key
}
