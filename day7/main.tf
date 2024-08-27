provider "aws" {
    region = "us-east-1" 
}

resource "aws_instance" "inst4" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    tags = {
        name = "inst4"
    }
}