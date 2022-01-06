resource "aws_instance" "main" {
  ami               = data.aws_ami.main.id
  availability_zone = var.az
  instance_type     = var.instance_type
  security_groups   = var.security_groups
  subnet_id         = var.subnet_id
  key_name          = var.key != null ? aws_key_pair.main["enable"].key_name : null

  tags = merge({ "Name" = var.name }, var.instance_tags)
}

resource "aws_key_pair" "main" {
  for_each = var.key != null ? toset(["enable"]) : []

  key_name   = var.key.name
  public_key = var.key.public_key
}
