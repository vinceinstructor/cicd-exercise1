# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "labexercise1"
    region = "us-east-1"
  }
}


# Create the VPC, subnets, internet gateway, and availability zones
resource "aws_vpc" "Devops-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Devops-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.Devops-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.Devops-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_b"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.Devops-vpc.id

  tags = {
    Name = "my_igw"
  }
}

# Create security group to allow ICMP, SSH, HTTP, and HTTPS traffic
resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  description = "Allow ICMP, SSH, HTTP, and HTTPS traffic"

  vpc_id = aws_vpc.Devops-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

# Create two EC2 instances
resource "aws_instance" "ec2_instance_1" {
  ami                    = "ami-036c2987dfef867fb" # Specify your AMI ID here
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "ec2_instance_1"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami                    = "ami-036c2987dfef867fb" # Specify your AMI ID here
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "ec2_instance_2"
  }
}

resource "aws_instance" "web-app1" {
  ami                    = "ami-04b70fa74e45c3917" # Specify your AMI ID here
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "web-app1"
  }
}

resource "aws_instance" "web-app2" {
  ami                    = "ami-04b70fa74e45c3917" # Specify your AMI ID here
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "web-app2"
  }
}