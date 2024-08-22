# creation of vpc
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "myvpc"
    }
}

# ceation of internet gateway
resource "aws_internet_gateway" "myIG" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        name = "myIG"
    }
}


# creation of subnet
resource "aws_subnet" "publicSN" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
        name = "publicSN"
    }
}

resource "aws_subnet" "privateSN" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.2.0/24"
    tags = {
        name = "privateSN"
    }  
}

# public route table creation and edit route
resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIG.id
    }
}

# RT1 subnet association
resource "aws_route_table_association" "cust" {
    route_table_id = aws_route_table.RT1.id   
    subnet_id = aws_subnet.publicSN.id
}

# private route table creation and edit route
resource "aws_route_table" "RT2" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.myNT.id
    }
}

# RT2 subnet association
resource "aws_route_table_association" "cust2" {
    route_table_id = aws_route_table.RT2.id
    subnet_id = aws_subnet.privateSN.id
} 

# elastic ip
resource "aws_eip" "myeip" {
    domain = "vpc"
}

# nat gatewway creation
resource "aws_nat_gateway" "myNT" {
    subnet_id = aws_subnet.publicSN.id
    allocation_id = aws_eip.myeip.id
    tags = {
        name = "myeip"
    }
}

# security group creation
resource "aws_security_group" "mySG" {
    name = "mySG"
    vpc_id = aws_vpc.myvpc.id
    tags = {
        name = "mySG"
    }

ingress {
    description = "ssh"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
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

# creation of instances
resource "aws_instance" "insta1" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    subnet_id = aws_subnet.publicSN.id
    vpc_security_group_ids = [aws_security_group.mySG.id]
}

resource "aws_instance" "insta2" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    subnet_id = aws_subnet.privateSN.id
    vpc_security_group_ids = [aws_security_group.mySG.id]
}