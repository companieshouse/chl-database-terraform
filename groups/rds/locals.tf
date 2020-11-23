locals {
  admin_cidrs    = join(",", concat(values(data.terraform_remote_state.networks.outputs.vpn_cidrs), values(data.terraform_remote_state.networks.outputs.internal_cidrs)))
                  # internal cidrs were pulled from remote state for , should be moved into vault
                  # were stored here:
                  # bucket = "${var.aws_profile}.terraform-state.ch.gov.uk"
                  # key    = "aws-common-infrastructure-terraform/common-${var.aws_region}/networking.tfstate"
  rds_subnet_ids = # heritage data subnets
  r53_zone_id    = # pull from vault?
  r53_zone_name  = # pull from vault?
  vpc_id         = # heritage vpc id
}
