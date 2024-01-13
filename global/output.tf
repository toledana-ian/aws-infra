output "route53_zone_name_servers_christiantoledana_com" {
  value = aws_route53_zone.christiantoledana_com.name_servers
}

output "acm_certificate_arn_christiantoledana_com" {
  value = aws_acm_certificate.christiantoledana_com.arn
}

output "route53_zone_name_christiantoledana_com" {
  value = aws_route53_zone.christiantoledana_com.name
}

output "route53_zone_id_christiantoledana_com" {
  value = aws_route53_zone.christiantoledana_com.id
}