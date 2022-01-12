resource "aws_route_table" "main" {
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = var.name }, var.route_table_tags)
}

resource "aws_route" "main" {
  count = length(var.routes)

  route_table_id         = aws_route_table.main.id
  destination_cidr_block = var.routes[count.index].dest_cidr
  gateway_id             = var.routes[count.index].gwid
  instance_id            = var.routes[count.index].instance_id
  nat_gateway_id         = var.routes[count.index].nat_gw
}

resource "aws_route_table_association" "main" {
  count = length(var.subnet_id)

  subnet_id      = var.subnet_id[count.index]
  route_table_id = aws_route_table.main.id
}
