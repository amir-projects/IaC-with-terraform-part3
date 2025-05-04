terraform {
  backend "s3" {
    bucket         = "my-tf-remote-state"
    key            = "env/dev/app.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}