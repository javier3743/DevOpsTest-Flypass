terraform {
  backend "s3" {
    bucket = "states-terraform"
    key    = "terraform.tfstate"
    region = "us-east-2"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
  }
}