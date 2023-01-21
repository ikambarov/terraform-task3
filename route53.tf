data "aws_route53_zone" "zone" {
  name = var.dns_zone
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "web"
  type    = "CNAME"
  ttl     = 5

  records = [aws_lb.task_alb.dns_name]
}