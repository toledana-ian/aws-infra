module "route_53_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "christiantoledana.com" = {}
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

module "route_53_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.route_53_zone.route53_zone_zone_id)[0]

  records = [
    {
      name    = "christiantoledana.com"
      type    = "A"
      ttl     = 300
      records = [
        "185.199.108.153",
      ]
    },
    {
      name    = "www"
      type    = "CNAME"
      ttl     = 300
      records = [
        "christiantoledana.com",
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}
