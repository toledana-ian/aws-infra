data "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "ctoledana-terraform-state"
    key    = "global/terraform.tfstate"
    region = "ap-southeast-1"
  }
}