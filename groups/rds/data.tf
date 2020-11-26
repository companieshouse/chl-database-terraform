data "aws_vpc" "selected" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.selected.id
  filter {
  name   = "tag:Name"
  values = ["sub-data-*"]
  }
}

data "vault_generic_secret" "secrets" {
  path = "applications/${var.aws_profile}/${var.environment}/${var.service}/configuration"
}

data "vault_generic_secret" "route_53" {
  path = "aws-accounts/${var.aws_account}/route-53"
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}

data "aws_route53_zone" "selected" {
  zone_id      = data.vault_generic_secret.route_53.data["route53-zone-id"]
  private_zone = true
}
