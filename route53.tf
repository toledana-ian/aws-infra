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

module "route_53_github_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.route_53_zone.route53_zone_zone_id)[0]

  records = [
    {
      name    = "www"
      type    = "A"
      ttl     = 300
      records = [
        "185.199.108.153",
        "185.199.109.153",
        "185.199.110.153",
        "185.199.111.153",
      ]
    },
    {
      name  = "christiantoledana.com"
      type  = "A"
      alias = {
        name = "www.christiantoledana.com"
      }
    },
    {
      name    = "_github-pages-challenge-toledana-ian"
      type    = "TXT"
      ttl     = 300
      records = [
        "813f9406ab172f340161ed3607c926",
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}

module "route_53_private_email_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.route_53_zone.route53_zone_zone_id)[0]

  records = [
    {
      name    = var.domain_name
      type    = "MX"
      ttl     = 300
      records = [
        "10 mx1.privateemail.com",
        "20 mx2.privateemail.com",
      ]
    },
    {
      name    = var.domain_name
      type    = "TXT"
      ttl     = 300
      records = [
        "v=spf1 include:spf.privateemail.com ~all",
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}
