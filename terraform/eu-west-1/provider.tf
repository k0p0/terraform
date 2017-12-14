terraform {
  backend "s3" {
    bucket = "atelier-formation-terraform"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-1"
}
