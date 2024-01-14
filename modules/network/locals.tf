locals {
  vpc_cidr_block = {
    production  = "10.0.0.0/16"
    staging     = "10.1.0.0/16"
    testing     = "10.2.0.0/16"
    development = "10.3.0.0/16"
  }

  subnet_public_cidr_block = {
    production  = "10.0.0.0/16"
    staging     = "10.1.0.0/16"
    testing     = "10.2.0.0/16"
    development = "10.3.0.0/16"
  }

  subnet_private_cidr_block = {
    production  = "10.0.1.0/16"
    staging     = "10.1.1.0/16"
    testing     = "10.2.1.0/16"
    development = "10.3.1.0/16"
  }
}