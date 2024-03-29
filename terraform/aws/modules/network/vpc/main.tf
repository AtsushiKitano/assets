resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge({ Name = var.name }, var.vpc_tags)
}

resource "aws_subnet" "main" {
  for_each = { for v in var.subnets : v.name => v }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge({ Name = each.value.name }, each.value.tags)
}

resource "aws_internet_gateway" "main" {
  for_each = var.public ? toset(["enabled"]) : toset([])

  vpc_id = aws_vpc.main.id

  tags = merge({ Name = var.name }, var.igw_tags)
}

resource "aws_security_group" "main" {
  for_each = var.security_group != null ? toset(["enable"]) : []

  name   = var.security_group.name
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" = var.security_group.name }, var.security_group.tags)
}

resource "aws_security_group_rule" "main" {
  count = var.security_group != null ? length(var.security_group.rules) : 0

  type              = var.security_group.rules[count.index].type
  cidr_blocks       = var.security_group.rules[count.index].cidr_blocks
  from_port         = var.security_group.rules[count.index].from_port
  to_port           = var.security_group.rules[count.index].to_port
  protocol          = var.security_group.rules[count.index].protocol
  security_group_id = aws_security_group.main["enable"].id
}
