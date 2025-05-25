terraform {
  backend "s3" {
    bucket         = "terraform-state-yourmentors"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    profile        = "yourmentors"
    encrypt        = true
  }
}