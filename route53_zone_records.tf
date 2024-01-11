resource "aws_route53_record" "www_christiantoledana_com" {
  name    = "www"
  type    = "A"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

resource "aws_route53_record" "christiantoledana_com" {
  name    = ""
  type    = "A"
  zone_id = aws_route53_zone.christiantoledana_com.id

  alias {
    name                   = "${aws_route53_record.www_christiantoledana_com.name}.${aws_route53_zone.christiantoledana_com.name}"
    zone_id                = aws_route53_zone.christiantoledana_com.id
    evaluate_target_health = false
  }
}