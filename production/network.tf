module "network" {
  source      = "../modules/network"
  environment = "production"

  tags = merge(local.default_tags, {
    Project = "network"
  })
}
