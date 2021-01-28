resource "aws_security_group" "main" {
  name   = var.sg.name
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = var.sg.name }, var.sg_tags)
}

resource "aws_security_group_rule" "main" {
  count = length(var.sg.rules)

  type              = var.sg.rules[count.index].type
  cidr_blocks       = var.sg.rules[count.index].cidr_blocks
  from_port         = var.sg.rules[count.index].from_port
  to_port           = var.sg.rules[count.index].to_port
  protocol          = var.sg.rules[count.index].protocol
  security_group_id = aws_security_group.main.id
}

resource "aws_network_acl" "main" {
  vpc_id     = var.vpc_id
  subnet_ids = var.ncl.subnet_ids
  tags       = merge({ "Name" = var.ncl.name }, var.ncl_tags)
}

resource "aws_network_acl_rule" "main" {
  count = length(var.ncl.rules)

  network_acl_id = aws_network_acl.main.id
  rule_number    = var.ncl.rules[count.index].rule_number
  egress         = var.ncl.rules[count.index].egress
  protocol       = var.ncl.rules[count.index].protocol
  rule_action    = var.ncl.rules[count.index].rule_action
  cidr_block     = var.ncl.rules[count.index].cidr
  from_port      = var.ncl.rules[count.index].from_port
  to_port        = var.ncl.rules[count.index].to_port
  icmp_type      = var.ncl.rules[count.index].icmp_type
  icmp_code      = var.ncl.rules[count.index].icmp_code
}
