
resource "aws_route53_record" "rds" {
  zone_id = local.r53_zone_id
  name    = "${var.service}.${local.r53_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.db.this_db_instance_address]
}
