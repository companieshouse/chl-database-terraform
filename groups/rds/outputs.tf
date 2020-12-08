output "rds_endpoint" {
  value = module.db.this_db_instance_address
}

output "rds_address" {
  value = aws_route53_record.rds.fqdn
}

output "rds_database_name" {
  value = module.db.this_db_instance_name
}

output "db_user" {
  value = module.db.this_db_instance_username
}

output "db_password" {
  value = module.db.this_db_instance_password
}
