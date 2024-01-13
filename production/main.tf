terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.31.0"
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

  default_tags = {
    ManagedBy = "Terraform"
    Environment = "Production"
  }
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}