# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${var.service}-rds-security-group"
  description = "Security group for the ${var.service} database"
  vpc_id      = data.aws_vpc.selected.id

  ingress_cidr_blocks = local.admin_cidrs
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
  major_engine_version = "12.1"
  engine_version    = "12.1.0.2.v21"
  license_model     = "license-included"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  multi_az          = var.multi_az
  storage_encrypted = true

  name     = upper(var.service)
  username = "testch"
  password = "testch"
  port     = "1521"

  deletion_protection     = true
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = "false"

  vpc_security_group_ids = [module.security_group.this_security_group_id]

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.data.ids

  tags = {
    Name        = var.service
    Service     = var.service
    Terraform   = "true"
  }
}
