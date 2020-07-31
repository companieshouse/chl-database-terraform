resource "aws_security_group" "rds_sg" {
  name        = "${var.service}-rds-security-group"
  description = "Security group for the ${var.service} database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 1522
    to_port         = 1522

    protocol        = "tcp"
    cidr_blocks     = var.admin_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service}-rds-sg"
    Service     = var.service
  }
}

resource "aws_db_subnet_group" "oracle_subnet_group" {
  name       = "${var.service}-rds-subnet-group"
  subnet_ids = var.rds_subnet_ids
  tags = {
    Name        = "${var.service}-rds-db-subnet-group"
    Service     = var.service
  }
}
