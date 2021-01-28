resource "aws_vpc" "main" {
  cidr_block = var.config.vpc.cidr
  tags       = merge({ "Name" = var.config.vpc.name }, var.vpc_tags)
}

resource "aws_subnet" "main" {
  for_each = { for v in var.config.subnets : v.name => v }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags              = merge({ "Name" = each.value.name }, lookup(var.subnet_tags, each.value.name, null))
}

resource "aws_internet_gateway" "main" {
  for_each = var.public ? toset(["enabled"]) : toset([])

  vpc_id = aws_vpc.main.id
  tags   = var.ig_tags
}
