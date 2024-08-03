terraform {
  backend "s3" {
    bucket = "state-terraform-javier.palacios"
    key    = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-state-lock"
  }
}