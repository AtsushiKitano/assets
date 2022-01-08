resource "aws_route53_resolver_endpoint" "main" {
  name      = var.name
  direction = var.direction

  security_group_ids = var.security_group_ids

  dynamic "ip_address" {
    for_each = var.ip_addresses
    iterator = _conf

    content {
      subnet_id = _conf.value.subnet_id
      ip        = _conf.value.ip
    }
  }

  tags = var.tags
}

resource "aws_route53_resolver_rule" "main" {
  for_each = { for v in var.resolver_rules : v.name => v }

  name                 = each.value.name
  rule_type            = each.value.type
  resolver_endpoint_id = aws_route53_resolver_endpoint.main.id

  dynamic "target_ip" {
    for_each = each.value.type == "FORWARD" ? each.value.targets : []
    iterator = _conf

    content {
      ip   = _conf.value.ip
      port = _conf.value.port
    }
  }

  tags = each.value.tags
}
