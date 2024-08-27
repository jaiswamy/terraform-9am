terraform {
  backend "s3" {
    bucket = "lionkingjai"
    region = "us-east-1"
    key = "dev/terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt = true
  }
}