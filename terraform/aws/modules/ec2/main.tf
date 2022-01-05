resource "aws_instance" "main" {
  ami               = data.aws_ami.main.id
  availability_zone = var.az
  instance_type     = var.instance_type
  security_groups   = var.security_groups
  subnet_id         = var.subnet_id

  tags = merge({ "Name" = var.name }, var.instance_tags)
}
