# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
provider "aws" {
  region  = var.aws_region
}

terraform {
  backend "s3" {
  }
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}

# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------
module "rds" {
  source = "./module-rds"
  admin_cidrs               = local.admin_cidrs
  allocated_storage         = var.allocated_storage
  aws_profile               = var.aws_profile
  backup_retention_period   = var.backup_retention_period
  database_username         = data.vault_generic_secret.secrets.data["database-username"]
  database_password         = data.vault_generic_secret.secrets.data["database-password"]
  instance_class            = var.instance_class
  maximum_storage           = var.maximum_storage
  multi_az                  = var.multi_az
  r53_zone_id               = var.r53_zone_id
  r53_zone_name             = var.r53_zone_name
  r53_create                = var.r53_create
  rds_subnet_ids            = local.rds_subnet_ids
  service                   = var.service
  vpc_id                    = local.vpc_id
}

# ------------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------------
locals {
  admin_cidrs                     = concat(values(data.terraform_remote_state.networks.outputs.vpn_cidrs), values(data.terraform_remote_state.networks.outputs.internal_cidrs))
  rds_subnet_ids                  = split(",", data.terraform_remote_state.test_and_develop_vpc.outputs.rds_ids)
  vpc_id                          = data.terraform_remote_state.test_and_develop_vpc.outputs.vpc_id
}

# ------------------------------------------------------------------------------
# Remote State
# ------------------------------------------------------------------------------
data "terraform_remote_state" "networks" {
  backend = "s3"
  config = {
    bucket = "${var.aws_profile}.terraform-state.ch.gov.uk"
    key    = "aws-common-infrastructure-terraform/common-${var.aws_region}/networking.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "test_and_develop_vpc" {
  backend = "s3"
  config = {
    bucket = var.network_state_bucket_name
    key    = "env:/${var.aws_account}/${var.aws_account}/${var.aws_account}.tfstate"
    region = var.aws_region
  }
}

data "vault_generic_secret" "secrets" {
  path = "applications/${var.aws_profile}/${var.environment}/${var.service}/configuration"
}

# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_database_name" {
  value = module.rds.rds_database
}

output "db_user" {
  value = module.rds.db_user
}

output "db_password" {
  value = module.rds.db_password
}
