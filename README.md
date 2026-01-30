# terraform-aws-endpoint

AWS VPC Endpoint를 생성하고 관리하는 Terraform 모듈입니다.

## 포함된 리소스

- VPC Endpoint (Gateway / Interface / GatewayLoadBalancer)

## 사용법

### 기본 사용 예시

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-vpc-endpoints.git"

  name   = "my-vpc"
  vpc_id = "vpc-0123456789abcdef0"

  # Gateway Endpoints
  vpc_endpoint_names         = ["s3", "dynamodb"]
  vpc_endpoint_service_names = [
    "com.amazonaws.ap-northeast-2.s3",
    "com.amazonaws.ap-northeast-2.dynamodb"
  ]
  vpc_endpoint_types = ["Gateway", "Gateway"]

  # Route Table 연결 (Gateway Endpoint용)
  vpc_endpoint_route_table_ids = {
    "s3"       = ["rtb-0123456789abcdef0", "rtb-0123456789abcdef1"]
    "dynamodb" = ["rtb-0123456789abcdef1"]
  }

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

### Interface Endpoint 설정 예시

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-vpc-endpoints.git"

  name   = "my-vpc"
  vpc_id = "vpc-0123456789abcdef0"

  # ... (VPC, Subnet, Route Table 설정)

  # Interface Endpoints
  vpc_endpoint_names         = ["ec2", "ecr-api", "ecr-dkr"]
  vpc_endpoint_service_names = [
    "com.amazonaws.ap-northeast-2.ec2",
    "com.amazonaws.ap-northeast-2.ecr.api",
    "com.amazonaws.ap-northeast-2.ecr.dkr"
  ]
  vpc_endpoint_types                = ["Interface", "Interface", "Interface"]
  vpc_endpoint_private_dns_enabled  = [true, true, true]

  # Subnet 연결 (Interface Endpoint용)
  vpc_endpoint_subnet_ids = {
    "ec2"     = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    "ecr-api" = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    "ecr-dkr" = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  }

  # Security Group 연결 (Interface Endpoint용)
  vpc_endpoint_security_group_ids = {
    "ec2"     = ["sg-0123456789abcdef0"]
    "ecr-api" = ["sg-0123456789abcdef0"]
    "ecr-dkr" = ["sg-0123456789abcdef0"]
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Gateway + Interface Endpoint 혼합 설정 예시

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-vpc-endpoints.git"

  name   = "my-vpc"
  vpc_id = "vpc-0123456789abcdef0"

  # ... (VPC, Subnet, Route Table 설정)

  # Gateway + Interface Endpoints
  vpc_endpoint_names = ["s3", "dynamodb", "ec2", "ecr-api"]
  vpc_endpoint_service_names = [
    "com.amazonaws.ap-northeast-2.s3",
    "com.amazonaws.ap-northeast-2.dynamodb",
    "com.amazonaws.ap-northeast-2.ec2",
    "com.amazonaws.ap-northeast-2.ecr.api"
  ]
  vpc_endpoint_types = ["Gateway", "Gateway", "Interface", "Interface"]
  vpc_endpoint_private_dns_enabled = [false, false, true, true]

  # Gateway Endpoint -> Route Table 연결
  vpc_endpoint_route_table_ids = {
    "s3"       = ["rtb-0123456789abcdef0", "rtb-0123456789abcdef1"]
    "dynamodb" = ["rtb-0123456789abcdef1"]
  }

  # Interface Endpoint -> Subnet, Security Group 연결
  vpc_endpoint_subnet_ids = {
    "ec2"     = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    "ecr-api" = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  }
  vpc_endpoint_security_group_ids = {
    "ec2"     = ["sg-0123456789abcdef0"]
    "ecr-api" = ["sg-0123456789abcdef0"]
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Policy 설정 예시

```hcl
module "vpc_endpoints" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-vpc-endpoints.git"

  name   = "my-vpc"
  vpc_id = "vpc-0123456789abcdef0"

  # ... (VPC, Subnet, Route Table 설정)

  vpc_endpoint_names         = ["s3"]
  vpc_endpoint_service_names = ["com.amazonaws.ap-northeast-2.s3"]
  vpc_endpoint_types         = ["Gateway"]

  # S3 Endpoint Policy
  vpc_endpoint_policies = [jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::my-bucket/*"
        ]
      }
    ]
  })]

  vpc_endpoint_route_table_ids = {
    "s3" = ["rtb-0123456789abcdef0"]
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

### VPC Endpoint

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | VPC Endpoint 이름 접두사 | `string` | - | yes |
| vpc_id | VPC ID | `string` | - | yes |

### VPC Endpoint Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_endpoint_names | VPC Endpoint 이름 목록 | `list(string)` | `[]` | no |
| vpc_endpoint_service_names | 서비스 이름 목록 | `list(string)` | `[]` | no |
| vpc_endpoint_types | Endpoint 타입 목록 (Gateway, Interface, GatewayLoadBalancer) | `list(string)` | `[]` | no |
| vpc_endpoint_auto_accept | auto_accept 값 목록 | `list(bool)` | `[]` | no |
| vpc_endpoint_policies | IAM 정책 목록 (JSON 형식) | `list(string)` | `[]` | no |
| vpc_endpoint_private_dns_enabled | private_dns_enabled 값 목록 (Interface type only) | `list(bool)` | `[]` | no |
| vpc_endpoint_ip_address_type | ip_address_type 값 목록 (ipv4, ipv6, dualstack) | `list(string)` | `[]` | no |
| vpc_endpoint_route_table_ids | Gateway Endpoint용 라우트 테이블 ID 연결 | `map(list(string))` | `{}` | no |
| vpc_endpoint_subnet_ids | Interface Endpoint용 서브넷 ID 연결 | `map(list(string))` | `{}` | no |
| vpc_endpoint_security_group_ids | Interface Endpoint용 보안 그룹 ID | `map(list(string))` | `{}` | no |
| vpc_endpoint_tags | VPC Endpoint별 추가 태그 | `map(map(string))` | `{}` | no |

### Common

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | 모든 리소스에 적용할 태그 | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_endpoint_ids | VPC Endpoint 이름별 ID 맵 |
| vpc_endpoint_arns | VPC Endpoint 이름별 ARN 맵 |
| vpc_endpoint_dns_entries | VPC Endpoint 이름별 DNS 엔트리 맵 (Interface type only) |
| vpc_endpoint_network_interface_ids | VPC Endpoint 이름별 네트워크 인터페이스 ID 맵 (Interface type only) |
| vpc_endpoint_prefix_list_ids | VPC Endpoint 이름별 Prefix List ID 맵 (Gateway type only) |
| vpc_endpoint_state | VPC Endpoint 이름별 상태 맵 |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 5.0.0 |
