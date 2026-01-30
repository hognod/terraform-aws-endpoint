################################################################################
# VPC Endpoints
################################################################################

resource "aws_vpc_endpoint" "main" {
  for_each = local.vpc_endpoints

  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.vpc_endpoint_type
  auto_accept         = each.value.auto_accept
  policy              = each.value.policy
  private_dns_enabled = each.value.vpc_endpoint_type == "Interface" ? each.value.private_dns_enabled : null
  ip_address_type     = each.value.ip_address_type
  route_table_ids     = each.value.vpc_endpoint_type == "Gateway" ? each.value.route_table_ids : null
  subnet_ids          = each.value.vpc_endpoint_type == "Interface" ? each.value.subnet_ids : null
  security_group_ids  = each.value.vpc_endpoint_type == "Interface" ? each.value.security_group_ids : null

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name = "${var.name}-${each.key}"
    }
  )
}
