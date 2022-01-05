resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "main" {
  for_each = { for v in var.subnets : v.name => v }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

resource "aws_internet_gateway" "main" {
  for_each = var.public ? toset(["enabled"]) : toset([])

  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "main" {
  for_each = { for v in var.security_groups : v.name => v }

  name   = each.value.name
  vpc_id = aws_vpc.main.id
  tags   = merge({ "Name" = each.value.name }, each.value.tags)
}

resource "aws_security_group_rule" "main" {
  count = var.security_groups != null ? length(var.security_groups.rules) : 0

  type              = var.security_groups.rules[count.index].type
  cidr_blocks       = var.security_groups.rules[count.index].cidr_blocks
  from_port         = var.security_groups.rules[count.index].from_port
  to_port           = var.security_groups.rules[count.index].to_port
  protocol          = var.security_groups.rules[count.index].protocol
  security_group_id = aws_security_group.main.id
}

