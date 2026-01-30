################################################################################
# VPC Endpoints
################################################################################

output "vpc_endpoint_ids" {
  description = "Map of VPC endpoint names to IDs"
  value       = { for k, v in aws_vpc_endpoint.main : k => v.id }
}

output "vpc_endpoint_arns" {
  description = "Map of VPC endpoint names to ARNs"
  value       = { for k, v in aws_vpc_endpoint.main : k => v.arn }
}

output "vpc_endpoint_dns_entries" {
  description = "Map of VPC endpoint names to DNS entries (Interface type only)"
  value       = { for k, v in aws_vpc_endpoint.main : k => v.dns_entry }
}

output "vpc_endpoint_network_interface_ids" {
  description = "Map of VPC endpoint names to network interface IDs (Interface type only)"
  value       = { for k, v in aws_vpc_endpoint.main : k => v.network_interface_ids }
}

output "vpc_endpoint_prefix_list_ids" {
  description = "Map of VPC endpoint names to prefix list IDs (Gateway type only)"
  value       = { for k, v in aws_vpc_endpoint.main : k => v.prefix_list_id }
}

output "vpc_endpoint_state" {
  description = "Map of VPC endpoint names to state"
  value       = { for k, v in aws_vpc_endpoint.main : k => v.state }
}
