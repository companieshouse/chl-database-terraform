# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
 type        = string
 description = "The AWS profile to use"
}

variable "aws_account" {
 type        = string
 description = "The name of the AWS Account in which resources will be administered"
}

variable "network_state_bucket_name" {
  type        = string
  description = "The name of the S3 bucket containing the application network remote state"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "service" {
  type        = string
  description = "The name of the service"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

# ------------------------------------------------------------------------------
# RDS Variables
# ------------------------------------------------------------------------------
variable "instance_class" {
  type = string
  description = "The type of instance for the RDS"
  default = "db.t3.medium"
}

variable "multi_az" {
  type = bool
  description = "Whether the RDS is Multi-AZ"
  default = false
}

variable "backup_retention_period" {
  type = number
  description = "The number of days to retain backups for - 0 to 35"
  default = "0"
}

variable "allocated_storage" {
  type = number
  description = "The amount of storage in GB to launch RDS with"
}

variable "maximum_storage" {
  type = number
  description = "The maximum storage in GB to allow RDS to scale to"
}

variable "auto_stop" {
  type = bool
  default = false
  description = "Whether to stop the RDS out of office hours"
}
# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}
variable "vault_password" {
  type = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}
