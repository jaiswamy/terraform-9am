provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "inst5" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    subnet_id = aws_subnet.publicSN.id
    depends_on = [ aws_vpc.cust ]
}

resource "aws_vpc" "cust" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "cust_vpc"
  }
}

resource "aws_subnet" "publicSN" {
  vpc_id            = aws_vpc.cust.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    name = "publicSN"
  }
}

resource "aws_s3_bucket" "kingkonh" {
    bucket = "kingkonh"
  
}