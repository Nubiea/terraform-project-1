

resource "aws_instance" "newec2" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
}
resource "aws_vpc" "vpc2" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "vp2"
    }
  
}
resource "aws_subnet" "public-sn"{ 
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnethomework"
  }
  }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "igwtag"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-sn.id
  route_table_id = aws_route_table.Rt-homework.id
}
resource "aws_route_table" "Rt-homework" {
  vpc_id = aws_vpc.vpc2.id

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
  vpc_id      = aws_vpc.vpc2.id

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
