# Configuring our provider

provider "aws" {
    region = var.region
  
}

# Creating our VPC

resource "aws_vpc" "demo" {
    cidr_block = var.cidr_blocks
    instance_tenancy = "default"

    tags = {
      name = "demo"
    }
  
}

# Creating our Subnets

resource "aws_subnet" "demopub" {
    vpc_id = aws_vpc.demo.id
    cidr_block = var.subnet_pub
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      name = "demopub"
    }
  
}

resource "aws_subnet" "demopriv" {
    vpc_id = aws_vpc.demo.id
    cidr_block = var.subnet_priv
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false

    tags = {
      name = "demopriv"
    }
  
}

# Creating Internet Gateway 

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.demo.id
  
}

# Creating Route Table for the Public

resource "aws_route_table" "pub1" {
    vpc_id = aws_vpc.demo.id
    
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

# Associating our Route Table

resource "aws_route_table_association" "rta" {
    route_table_id = aws_route_table.pub1.id
    subnet_id = aws_subnet.demopub.id

}

# Creating Security Groups

resource "aws_security_group" "sg" {
    vpc_id = aws_vpc.demo.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
   ingress {
        from_port = 8080
        to_port = 8080
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

# Creating an EC2 Instance

resource "aws_instance" "demo" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key
    subnet_id = aws_subnet.demopub.id
    security_groups = [aws_security_group.sg.id]

    tags = {
      name = "demopub"
    }

    count = var.instance
  user_data = {
    
  }
}