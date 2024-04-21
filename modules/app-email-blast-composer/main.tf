terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.31.0"
      configuration_aliases = [
        aws.default,
        aws.us_east_1
      ]
    }
  }
}
