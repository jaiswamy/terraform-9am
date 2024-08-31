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
    map_public_ip_on_launch = true
    tags = {
        name = "publicsn"
    }
}

resource "aws_subnet" "private_sn" {
    vpc_id = aws_vpc.myvpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.2.0/24"
    tags = {
        name = "privatesn"
    }
}

resource "aws_internet_gateway" "myig" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        name = "myig"
    }
}

resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myig.id
    }
}

resource "aws_route_table_association" "cust" {
    route_table_id = aws_route_table.RT1.id
    subnet_id = aws_subnet.public_sn.id
}

resource "aws_eip" "myeip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "myng" {
    subnet_id = aws_subnet.public_sn.id
    allocation_id = aws_eip.myeip.id  
    tags = {
        name = "myng"
    }
}

resource "aws_route_table" "RT2" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.myng.id
    }
}

resource "aws_route_table_association" "cust1" {
    route_table_id = aws_route_table.RT2.id
    subnet_id = aws_subnet.private_sn.id
}

resource "aws_security_group" "mysg" {
    vpc_id = aws_vpc.myvpc.id
    description = "security groups for instance"
    tags = {
        name = "mysg"
    }

ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

ingress {
    description = "http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

egress {
    from_port = 0
    to_port = 0
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "inst1" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    subnet_id = aws_subnet.public_sn.id
    vpc_security_group_ids = [aws_security_group.mysg.id]
    tags = {
        name = "inst1"
    }
}

resource "aws_instance" "inst2" {
    ami = "ami-066784287e358dad1"
    instance_type = "t2.micro"
    key_name = "us"
    subnet_id = aws_subnet.private_sn.id
    vpc_security_group_ids = [aws_security_group.mysg.id]
    user_data = file("file.sh")
    tags = {
        name = "inst2"
    }
}


