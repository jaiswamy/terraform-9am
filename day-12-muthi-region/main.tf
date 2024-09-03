provider "aws" {
    region = "us-east-1"
    alias = "us"

}

provider "aws" {
    region = "ap-south-1"
    alias = "mumbai"
}

provider "aws" {
    region = "us-west-1"
}

resource "aws_s3_bucket" "mumbai" {
    bucket = "mumbaidoook"
    provider = aws.mumbai
}

resource "aws_s3_bucket" "us" {
    bucket = "usesuses"
    provider = aws.us
}

resource "aws_s3_bucket" "usa" {
    bucket = "useastone"
}
