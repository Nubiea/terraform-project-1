provider "aws" {
  region  = "us-east-1"
  access_key = "AKIATU7EI25FV4OIXR5N"
  secret_key = "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"
}

resource "aws_instance" "practiceEC2" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
}
resource "aws_vpc" "homework-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "homeworkvpc"
    }
  
}
resource "aws_subnet" "public-sn"{ 
  vpc_id     = aws_vpc.homework-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnethomework"
  }
  }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.homework-vpc.id

  tags = {
    Name = "igwtag"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-sn.id
  route_table_id = aws_route_table.Rt-homework.id
}
resource "aws_route_table" "Rt-homework" {
  vpc_id = aws_vpc.homework-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt"
  }
}

resource "aws_security_group" "homework-sg" {
  name        = "allow_https"
  description = "allow_httpsinbound"
  vpc_id      = aws_vpc.homework-vpc.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
 ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sgtag"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.terraformkey
}


    
  