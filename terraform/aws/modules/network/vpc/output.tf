output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "subnet_id" {
  value = {
    for v in var.config.subnets : v.name => aws_subnet.main[v.name].id
  }
}

output "subnet_arn" {
  value = {
    for v in var.config.subnets : v.name => aws_subnet.main[v.name].arn
  }
}

output "subnet_cidr" {
  value = {
    for v in var.config.subnets : v.name => aws_subnet.main[v.name].cidr_block
  }
}

output "igw" {
  value = var.public == true ? aws_internet_gateway.main["enabled"].id : null
}
