terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.46.0"
    }
  }

  backend "s3" {
    bucket         = "ctoledana-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "ctoledana-terraform-state-lock"
  }
}

provider "aws" {
  alias = "default"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
