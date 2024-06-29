provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc_ppal" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
  }
}


resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc_ppal.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "publicSubRed_1"
  }
}


resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc_ppal.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b" 

  tags = {
    Name = "publicSubRed_2"
  }
}


resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc_ppal.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"  

  tags = {
    Name = "privateSubRed_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.vpc_ppal.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"  

  tags = {
    Name = "privateSubRed_2"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_ppal.id

  tags = {
    Name = "main_igw"
  }
}


resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_ppal.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "publicRuta"
  }
}

resource "aws_route_table_association" "public_1_association" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_2_association" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_route.id
}


// instances

resource "aws_security_group" "sec_group" {
  name        = "instance"
  description = "Security group for EC2 instance"

  vpc_id = aws_vpc.vpc_ppal.id


  ingress {
    from_port   = 0
    to_port     = 65535
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


resource "aws_instance" "Instance_1" {
  ami           = "ami-04b70fa74e45c3917"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1.id

  vpc_security_group_ids = [
    aws_security_group.sec_group.id  
  ]
  tags = {
    Name = "Instance2"
  }
}

resource "aws_instance" "Instance_2" {
  ami           = "ami-04b70fa74e45c3917"  
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_2.id

  vpc_security_group_ids = [
    aws_security_group.sec_group.id  
  ]
  tags = {
    Name = "Instance2"
  }
}