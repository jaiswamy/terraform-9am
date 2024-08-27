resource "aws_vpc" "cust" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "cust_vpc"
  }
}


resource "aws_internet_gateway" "cust_ig" {
  vpc_id = aws_vpc.cust.id
  tags = {
    name = "ig1"
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
resource "aws_subnet" "privateSN" {
  vpc_id            = aws_vpc.cust.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.2.0/24"
  tags = {
    name = "privateSN"
  }
}

resource "aws_route_table" "RT1" {
  vpc_id = aws_vpc.cust.id
  route {
    gateway_id = aws_internet_gateway.cust_ig.id
    cidr_block = "0.0.0.0/0"
  }

}

resource "aws_route_table_association" "cust" {
  route_table_id = aws_route_table.RT1.id
  subnet_id      = aws_subnet.publicSN.id
}

resource "aws_route_table" "RT2" {
  vpc_id = aws_vpc.cust.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myNG.id
  }
}

resource "aws_route_table_association" "cust2" {
  subnet_id      = aws_subnet.privateSN.id
  route_table_id = aws_route_table.RT2.id
}

resource "aws_eip" "myeip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "myNG" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.publicSN.id
  tags = {
    name = "cust_NG"
  }
}

resource "aws_security_group" "mysg" {
  name   = "mysg"
  vpc_id = aws_vpc.cust.id
  tags = {
    name = "mysg"
  }

ingress {
  description = "ssh"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
ingress {
  description = "http"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_instance" "inst1" {
  ami                    = "ami-066784287e358dad1"
  instance_type          = "t2.micro"
  key_name               = "us"
  subnet_id              = aws_subnet.publicSN.id
  vpc_security_group_ids = [aws_security_group.mysg.id]
}
resource "aws_instance" "inst2" {
  ami                    = "ami-066784287e358dad1"
  instance_type          = "t2.micro"
  key_name               = "us"
  subnet_id              = aws_subnet.privateSN.id
  vpc_security_group_ids = [aws_security_group.mysg.id]
}

# lifecycle {
#   create_before_destroy = true
# }

# lifecycle {
#   privent_destroy = true
# }

resource "aws_s3_bucket" "name" {
  bucket = "kinjaisbucket"
  
}