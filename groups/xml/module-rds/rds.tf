resource "aws_db_instance" "oracle" {
  identifier             = var.service
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.maximum_storage
  storage_type           = "gp2"
  engine                 = "oracle-se2"
  engine_version         = "12.1.0.2.v20"
  instance_class         = var.instance_class
  name                   = upper(var.service)
  username               = var.database_username
  password               = var.database_password
  license_model          = "license-included"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.oracle_subnet_group.name
  port                   = 1522
  option_group_name      = aws_db_option_group.s3_integration.name

  deletion_protection     = true
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az

  tags = {
    Name        = var.service
    Service     = var.service
  }
}

# ------------------------------------------------------------------------------
# Route53
# ------------------------------------------------------------------------------
data "aws_route53_zone" "r53zone" {
  count = var.r53_create ? 1 : 0
  name  = var.r53_zone_name
}

resource "aws_route53_record" "oracle_rds" {
  count   = var.r53_create ? 1 : 0
  zone_id = data.aws_route53_zone.r53zone[0].zone_id
  name    = "${var.service}.${var.r53_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.oracle.address]
}
