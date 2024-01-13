resource "aws_route53_record" "private_email_mx_admin_christiantoledana_com" {
  name    = ""
  type    = "MX"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "10 mx1.privateemail.com",
    "10 mx2.privateemail.com",
  ]
}

resource "aws_route53_record" "private_email_txt_admin_christiantoledana_com" {
  name    = ""
  type    = "TXT"
  zone_id = aws_route53_zone.christiantoledana_com.id
  ttl     = 300

  records = [
    "v=spf1 include:spf.privateemail.com ~all",
  ]
}