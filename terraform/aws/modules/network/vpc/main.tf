resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "main" {
  for_each = { for v in var.subnetworks : v.name => v }

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
    Name = name
  }
}
