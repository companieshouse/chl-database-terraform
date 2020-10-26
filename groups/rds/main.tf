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
# Locals
# ------------------------------------------------------------------------------
locals {
  admin_cidrs                     = concat(values(data.terraform_remote_state.networks.outputs.vpn_cidrs), values(data.terraform_remote_state.networks.outputs.internal_cidrs))
  rds_subnet_ids                  = split(",", data.terraform_remote_state.test_and_develop_vpc.outputs.rds_ids)
  vpc_id                          = data.terraform_remote_state.test_and_develop_vpc.outputs.vpc_id
}

# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name   = "${var.service}-rds-security-group"
  vpc_id = local.vpc_id
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  create_db_parameter_group = "false"
  create_db_subnet_group = "true"

  identifier        = var.service
  engine            = "oracle-se2"
  engine_version    = "12.1.0.2.v21"
  license_model     = "license-included"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  multi_az          = var.multi_az

  name     = upper(var.service)
  username = data.vault_generic_secret.secrets.data["database-username"]
  password = data.vault_generic_secret.secrets.data["database-password"]
  port     = "1522"

  deletion_protection     = true
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = "14"
  skip_final_snapshot     = "false"

  vpc_security_group_ids = [module.security-group.this_security_group_id]

  # DB subnet group
  subnet_ids = local.rds_subnet_ids

  # DB option group
  option_group_name = "oracle-se2-12-1-s3-integration"
  major_engine_version = "12.1"
  option_group_description = "Allows Integration with s3"

  options = [
      {
        option_name = "S3_INTEGRATION"
        version = "1.0"
      },
    ]

  tags = {
    Name        = var.service
    Service     = var.service
    Terraform   = "true"
  }
}

# ------------------------------------------------------------------------------
# Role Association
# ------------------------------------------------------------------------------
data "aws_iam_role" "chl-db-dump-read-s3-role" {
  name = "chl-db-dump-read-s3-role"
}

resource "aws_db_instance_role_association" "s3_read" {
  db_instance_identifier = module.db.this_db_instance_arn
  feature_name           = "S3_INTEGRATION"
  role_arn               = data.aws_iam_role.chl-db-dump-read-s3-role.arn
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
