
resource "aws_route53_record" "rds" {
  zone_id = data.vault_generic_secret.route_53.data["route53-zone-id"]
  name    = "${var.service}.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [module.db.this_db_instance_address]
}
