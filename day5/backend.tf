terraform {
  backend "s3" {
    bucket = "kinjaisbucket"
    region = "us-east-1"
    key = "dev/terraform.tfstate"
  }
}