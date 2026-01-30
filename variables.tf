################################################################################
# VPC Endpoint
################################################################################

variable "name" {
  description = <<-EOF
    Name prefix for all VPC endpoints.
    Example: "my-vpc"
  EOF
  type        = string
}

variable "vpc_id" {
  description = <<-EOF
    VPC ID to create the VPC endpoints in.
    Example: "vpc-0123456789abcdef0"
  EOF
  type        = string
}

################################################################################
# VPC Endpoint Configuration
################################################################################

variable "vpc_endpoint_names" {
  description = <<-EOF
    List of VPC endpoint names.
    Example: ["s3", "dynamodb", "ec2"]
  EOF
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_service_names" {
  description = <<-EOF
    List of service names for VPC endpoints. Must match the order of vpc_endpoint_names.
    Example: ["com.amazonaws.ap-northeast-2.s3", "com.amazonaws.ap-northeast-2.dynamodb", "com.amazonaws.ap-northeast-2.ec2"]
  EOF
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_types" {
  description = <<-EOF
    List of VPC endpoint types. Must match the order of vpc_endpoint_names.
    Valid values: "Gateway", "Interface", "GatewayLoadBalancer"
    Example: ["Gateway", "Gateway", "Interface"]
  EOF
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_auto_accept" {
  description = <<-EOF
    List of auto_accept values for VPC endpoints.
    Example: [false, false, true]
  EOF
  type        = list(bool)
  default     = []
}

variable "vpc_endpoint_policies" {
  description = <<-EOF
    List of IAM policies for VPC endpoints (JSON format).
    Example: ["", "", ""]
  EOF
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_private_dns_enabled" {
  description = <<-EOF
    List of private_dns_enabled values for VPC endpoints (Interface type only).
    Example: [false, false, true]
  EOF
  type        = list(bool)
  default     = []
}

variable "vpc_endpoint_ip_address_type" {
  description = <<-EOF
    List of ip_address_type values for VPC endpoints.
    Valid values: "ipv4", "ipv6", "dualstack"
    Example: ["ipv4", "ipv4", "ipv4"]
  EOF
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_route_table_ids" {
  description = <<-EOF
    Map of VPC endpoint names to list of route table IDs (Gateway type only).
    Key: vpc_endpoint name (from vpc_endpoint_names)
    Value: list of route table IDs
    Example: {
      "s3"       = ["rtb-0123456789abcdef0", "rtb-0123456789abcdef1"]
      "dynamodb" = ["rtb-0123456789abcdef1"]
    }
  EOF
  type        = map(list(string))
  default     = {}
}

variable "vpc_endpoint_subnet_ids" {
  description = <<-EOF
    Map of VPC endpoint names to list of subnet IDs (Interface type only).
    Key: vpc_endpoint name (from vpc_endpoint_names)
    Value: list of subnet IDs
    Example: {
      "ec2" = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    }
  EOF
  type        = map(list(string))
  default     = {}
}

variable "vpc_endpoint_security_group_ids" {
  description = <<-EOF
    Map of VPC endpoint names to list of security group IDs (Interface type only).
    Key: vpc_endpoint name (from vpc_endpoint_names)
    Value: list of security group IDs
    Example: {
      "ec2" = ["sg-0123456789abcdef0"]
    }
  EOF
  type        = map(list(string))
  default     = {}
}

variable "vpc_endpoint_tags" {
  description = <<-EOF
    Map of VPC endpoint names to additional tags.
    Key: vpc_endpoint name (from vpc_endpoint_names)
    Value: map of tags
    Example: {
      "s3"  = { Service = "s3" }
      "ec2" = { Service = "ec2" }
    }
  EOF
  type        = map(map(string))
  default     = {}
}

################################################################################
# Common
################################################################################

variable "tags" {
  description = <<-EOF
    Tags to apply to all resources.
    Example: {
      Environment = "dev"
      Project     = "my-project"
      ManagedBy   = "terraform"
    }
  EOF
  type        = map(string)
  default     = {}
}
