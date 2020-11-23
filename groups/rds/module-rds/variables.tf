# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------
variable "service" {
  type        = string
  description = "The name of the service"
}

variable "aws_profile" {
 type        = string
 description = "The AWS profile to use"
}

# ------------------------------------------------------------------------------
# Network Variables
# ------------------------------------------------------------------------------
variable "vpc_id" {
  type        = string
  description = "The VPC to launch resources in"
}

variable "admin_cidrs" {
  type = list(string)
  description = "The cidrs to allow access from for connection"
}

variable "rds_subnet_ids" {
  type        = list(string)
  description = "The list of subnets to use for the RDS"
}

# ------------------------------------------------------------------------------
# Route53 Variables
# ------------------------------------------------------------------------------
variable "r53_zone_name" {
  type        = string
  description = "The Zone name of the Route53 record"
}

variable "r53_create" {
  type        = bool
  description = "Whether to create a Route53 record"
}

variable "r53_zone_id" {
  type        = string
  description = "The ZoneID of the Route53 record"
}

# ------------------------------------------------------------------------------
# RDS Variables
# ------------------------------------------------------------------------------
variable "database_username" {
  type = string
  description = "The username for the database - retrieved from Vault"
}

variable "database_password" {
  type = string
  description = "The password for the database - retrieved from Vault"
}

variable "instance_class" {
  type = string
  description = "The type of instance for the RDS"
}

variable "multi_az" {
  type = bool
  description = "Whether the RDS is Multi-AZ"
}

variable "backup_retention_period" {
  type = number
  description = "The number of days to retain backups for - 0 to 35"
}

variable "allocated_storage" {
  type = number
  description = "The amount of storage in GB to launch RDS with"
}

variable "maximum_storage" {
  type = number
  description = "The maximum storage in GB to allow RDS to scale to"
}
