resource "aws_route53_record" "sendgrid_url1984_christiantoledana_com" {
  name    = "url1984"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_41246841_christiantoledana_com" {
  name    = "41246841"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_em1918_christiantoledana_com" {
  name    = "em1918"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "u41246841.wl092.sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_s1_domainkey_christiantoledana_com" {
  name    = "s1._domainkey"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "s1.domainkey.u41246841.wl092.sendgrid.net",
  ]
}

resource "aws_route53_record" "sendgrid_s2_domainkey_christiantoledana_com" {
  name    = "s2._domainkey"
  type    = "CNAME"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "s2.domainkey.u41246841.wl092.sendgrid.net",
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