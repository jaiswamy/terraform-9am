provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "myvpc"
    }
}

resource "aws_subnet" "public_sn" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
        name = "publicsn"
    }
}


resource "aws_instance" "inst1" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    availability_zone = "us-east-1a"
    subnet_id = aws_subnet.public_sn.id
    user_data = file("test.sh")
    count = length(var.test)
    tags = {
        name = var.test[count.index]
    }
}
variable "test" {
    type = list(string)
    default = ["dev","cont","prod"]
}