#VPC
resource "aws_vpc" "ans" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ans"
  }
}

#subnet1
resource "aws_subnet" "ans-sn-1" {
  vpc_id     = aws_vpc.ans.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ans-sn-public"
  }
}

#subnet2
resource "aws_subnet" "ans-sn-2" {
  vpc_id     = aws_vpc.ans.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "ans-sn-private"
  }
}

#internetgateway
resource "aws_internet_gateway" "ans-igw" {
  vpc_id = aws_vpc.ans.id

  tags = {
    Name = "ans"
  }
}

#ROute table 1
resource "aws_route_table" "ans-rt-1" {
  vpc_id = aws_vpc.ans.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ans-igw.id
  }

  tags = {
    Name = "ans public rt"
  }
}

#ROute table 2
resource "aws_route_table" "ans-rt-2" {
  vpc_id = aws_vpc.ans.id

   tags = {
    Name = "ans private rt"
  }
}

#subnet association 1
resource "aws_route_table_association" "ans-sn-1-asc" {
  subnet_id      = aws_subnet.ans-sn-1.id
  route_table_id = aws_route_table.ans-rt-1.id
}

#subnet association 2
resource "aws_route_table_association" "ans-sn-2-asc" {
  subnet_id      = aws_subnet.ans-sn-2.id
  route_table_id = aws_route_table.ans-rt-2.id
}

#Master security group
resource "aws_security_group" "ans_master_sg" {
  name        = "SSH"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.ans.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow SSH"
  }
}


#Nodes security group
resource "aws_security_group" "ans_nodes_sg" {
  name        = "SSH & http"
  description = "Allow SSH & http inbound traffic"
  vpc_id      = aws_vpc.ans.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http from VPC"
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
  }

  tags = {
    Name = "allow SSH & http"
  }
}

