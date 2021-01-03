provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "web_tier" {
  cidr_block = "192.168.0.0/16"

  tags = {
    "tier" = "web"
  }
}

resource "aws_subnet" "internet" {
  vpc_id     = aws_vpc.web_tier.id
  cidr_block = "192.168.10.0/24"

  tags = {
    "tier" = "web"
  }
}

resource "aws_instance" "web_server" {
  ami             = "ami-09d9c5cdcfb8fc655" // RHEL
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.internet.id
  security_groups = [aws_security_group.ingress_ssh_allow.id]

  tags = {
    "os" = "rhel"
  }
}

resource "aws_security_group" "ingress_ssh_allow" {
  name        = "allow_ssh"
  description = "allow ssh from my public ip"
  vpc_id      = aws_vpc.web_tier.id

  ingress {
    cidr_blocks = ["173.229.10.117/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    "protocol" = "ssh"
    "ports"    = "22"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web_server.public_ip
}