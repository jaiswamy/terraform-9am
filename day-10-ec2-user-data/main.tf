provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "inst1" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    availability_zone = "us-east-1a"
    user_data = file("test.sh")
    tags = {
        name = "inst1"
    }
}