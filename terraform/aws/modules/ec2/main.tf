resource "aws_instance" "main" {
  ami               = data.aws_ami.main.id
  availability_zone = var.config.az
  instance_type     = var.config.instance_type
  security_groups   = var.config.security_groups
  subnet_id         = var.config.subnet_id

  tags = merge({ "Name" = var.config.name }, var.instance_tags)
}
