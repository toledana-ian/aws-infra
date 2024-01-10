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
      name  = ""
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
      name    = ""
      type    = "MX"
      ttl     = 300
      records = [
        "10 mx1.privateemail.com",
        "20 mx2.privateemail.com",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 300
      records = [
        "v=spf1 include:spf.privateemail.com ~all",
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}

module "route_53_amazon_ses_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.route_53_zone.route53_zone_zone_id)[0]

  records = [
    {
      name    = "wfma2ebkokzuq3hqaplu7cwyp4ynf3uq._domainkey"
      type    = "CNAME"
      ttl     = 300
      records = [
        "wfma2ebkokzuq3hqaplu7cwyp4ynf3uq.dkim.amazonses.com",
      ]
    },
    {
      name    = "u66p5fgjcwkoojzyd7g3xk7emjiygskc._domainkey"
      type    = "CNAME"
      ttl     = 300
      records = [
        "u66p5fgjcwkoojzyd7g3xk7emjiygskc.dkim.amazonses.com",
      ]
    },
    {
      name    = "caqymiro45yr3vmnl4m6fzkt22cmvd4i._domainkey"
      type    = "CNAME"
      ttl     = 300
      records = [
        "caqymiro45yr3vmnl4m6fzkt22cmvd4i.dkim.amazonses.com",
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}

module "route_53_dynamdev_app_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = keys(module.route_53_zone.route53_zone_zone_id)[0]

  records = [
    {
      name    = var.sud_domain_dynamdev_email_blast
      type    = "CNAME"
      ttl     = 300
      records = [
        module.dynamdev_email_blast_webapp_s3.s3_bucket_website_endpoint,
      ]
    },
  ]

  depends_on = [module.route_53_zone]
}