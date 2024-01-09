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

module "route_53_sendgrid_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.route_53_zone.route53_zone_zone_id)[0]

  records = [
    {
      name    = "em9467"
      type    = "CNAME"
      ttl     = 300
      records = [
        "u26320669.wl170.sendgrid.net",
      ]
    },
    {
      name    = "s1._domainkey"
      type    = "CNAME"
      ttl     = 300
      records = [
        "s1.domainkey.u26320669.wl170.sendgrid.net",
      ]
    },
    {
      name    = "s2._domainkey"
      type    = "CNAME"
      ttl     = 300
      records = [
        "s2.domainkey.u26320669.wl170.sendgrid.net",
      ]
    },
    {
      name    = "url7048"
      type    = "CNAME"
      ttl     = 300
      records = [
        "sendgrid.net",
      ]
    },
    {
      name    = "26320669"
      type    = "CNAME"
      ttl     = 300
      records = [
        "sendgrid.net",
      ]
    },
    {
      name    = "_dmarc"
      type    = "TXT"
      ttl     = 300
      records = [
        "v=DMARC1; p=none;",
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}