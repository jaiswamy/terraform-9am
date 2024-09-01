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

resource "aws_instance" "test" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    subnet_id = aws_subnet.public_sn.id
    key_name = "us"
    for_each = toset(var.test)
    
  tags = {
    #Name = "dev-1"
    Name = each.value
    
  }
}

variable "test" {
    type = list(string)
    default = [ "dev","cout"]
  
}