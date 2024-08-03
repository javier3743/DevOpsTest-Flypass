terraform {
  backend "s3" {
    bucket = "states-terraform"
    key    = "terraform.tfstate"
    region = var.region
  }
}