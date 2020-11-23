# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.service}-rds-security-group"
  description = "Security group for the ${var.service} database"
  vpc_id      = local.vpc_id

  ingress_cidr_blocks = [local.admin_cidrs]
  ingress_rules       = ["oracle-db-tcp"]
  egress_rules        = ["all-all"]
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
  port     = "1521"

  deletion_protection     = true
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = var.backend_retention_period
  skip_final_snapshot     = "false"

  vpc_security_group_ids = [module.security_group.this_security_group_id]

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
    AutoStop    = var.auto_stop
  }
}
