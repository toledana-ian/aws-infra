terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.31.0"
    }
  }

  backend "s3" {
    bucket         = "ctoledana-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "ctoledana-terraform-state-lockid"
  }
}

provider "aws" {
  alias = "default"
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}