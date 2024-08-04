data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "state-terraform-javier.palacios"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
