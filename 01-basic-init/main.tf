provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket        = "my-terraform-basic-bucket"
  force_destroy = true
}