resource "aws_route_table" "main" {
  vpc_id = var.config.vpc_id
  tags   = merge({ "Name" = var.config.name }, var.route_table_tags)
}

resource "aws_route" "main" {
  count = length(var.config.routes)

  route_table_id         = aws_route_table.main.id
  destination_cidr_block = var.config.routes[count.index].dest_cidr
  gateway_id             = var.config.routes[count.index].gwid
  instance_id            = var.config.routes[count.index].instance_id
  nat_gateway_id         = var.config.routes[count.index].nat_gw
}

resource "aws_route_table_association" "main" {
  for_each = var.assign_subnet

  subnet_id      = each.value
  route_table_id = aws_route_table.main.id
}
