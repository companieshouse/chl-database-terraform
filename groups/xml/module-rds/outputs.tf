output "rds_endpoint" {
  value = aws_db_instance.oracle.address
}

output "rds_database" {
  value = aws_db_instance.oracle.name
}

output "db_user" {
  value = aws_db_instance.oracle.username
}

output "db_password" {
  value = aws_db_instance.oracle.password
}
