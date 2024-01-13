resource "aws_route53_record" "sendgrid_url9423_christiantoledana_com" {
  name    = "url9423"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_26320669_christiantoledana_com" {
  name    = "26320669"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_em5688_christiantoledana_com" {
  name    = "em5688"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "u26320669.wl170.sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_s1_domainkey_christiantoledana_com" {
  name    = "s1._domainkey"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "s1.domainkey.u26320669.wl170.sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_s2_domainkey_christiantoledana_com" {
  name    = "s2._domainkey"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "s2.domainkey.u26320669.wl170.sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_dmarc_christiantoledana_com" {
  name    = "_dmarc"
  type    = "TXT"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "v=DMARC1; p=none;",
  ]
}