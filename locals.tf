locals {
  ################################################################################
  # VPC Endpoints
  ################################################################################

  vpc_endpoints = {
    for idx, name in var.vpc_endpoint_names : name => {
      service_name        = var.vpc_endpoint_service_names[idx]
      vpc_endpoint_type   = length(var.vpc_endpoint_types) > idx ? var.vpc_endpoint_types[idx] : "Interface"
      auto_accept         = length(var.vpc_endpoint_auto_accept) > idx ? var.vpc_endpoint_auto_accept[idx] : null
      policy              = length(var.vpc_endpoint_policies) > idx ? (var.vpc_endpoint_policies[idx] != "" ? var.vpc_endpoint_policies[idx] : null) : null
      private_dns_enabled = length(var.vpc_endpoint_private_dns_enabled) > idx ? var.vpc_endpoint_private_dns_enabled[idx] : null
      ip_address_type     = length(var.vpc_endpoint_ip_address_type) > idx ? var.vpc_endpoint_ip_address_type[idx] : null
      route_table_ids     = lookup(var.vpc_endpoint_route_table_ids, name, [])
      subnet_ids          = lookup(var.vpc_endpoint_subnet_ids, name, [])
      security_group_ids  = lookup(var.vpc_endpoint_security_group_ids, name, [])
      tags                = lookup(var.vpc_endpoint_tags, name, {})
    }
  }
}
