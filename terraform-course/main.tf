provider "aws" {
  region = var.aws_region
}

variable "aws_region" {}
variable "ami" {}
variable "my_public_ip" {}
variable "ssh_public_key" {}

resource "aws_vpc" "web_tier" {
  cidr_block = "192.168.0.0/16"

  tags = {
    "tier" = "web"
  }
}

resource "aws_internet_gateway" "web_tier_gw" {
  vpc_id = aws_vpc.web_tier.id

  tags = {
    "tier" = "web"
  }
}

resource "aws_route_table" "web_tier_rt" {
  vpc_id = aws_vpc.web_tier.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_tier_gw.id
  }

  tags = {
    "tier" = "web"
  }
}

resource "aws_route_table_association" "web_tier_rt_association" {
  subnet_id      = aws_subnet.internet.id
  route_table_id = aws_route_table.web_tier_rt.id
}

resource "aws_subnet" "internet" {
  vpc_id     = aws_vpc.web_tier.id
  cidr_block = "192.168.10.0/24"

  tags = {
    "tier" = "web"
  }
}

resource "aws_instance" "web_server" {
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.internet.id
  security_groups = [aws_security_group.ingress_ssh_allow.id]
  key_name        = aws_key_pair.ssh_key.key_name

  tags = {
    "os" = "rhel"
  }
}

resource "aws_security_group" "ingress_ssh_allow" {
  name        = "allow_ssh"
  description = "allow ssh from my public ip"
  vpc_id      = aws_vpc.web_tier.id

  ingress {
    cidr_blocks = [var.my_public_ip]
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

resource "aws_key_pair" "ssh_key" {
  key_name   = "web_server_ssh_key"
  public_key = var.ssh_public_key
}

resource "aws_eip" "web_server_public_ip" {
  instance   = aws_instance.web_server.id
  vpc        = true
  depends_on = [aws_internet_gateway.web_tier_gw]

  tags = {
    "tier" = "web"
  }
}

output "ec2_public_ip" {
  value = aws_eip.web_server_public_ip.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.web_server.private_ip
}

output "ec2_instance_id" {
  value = aws_instance.web_server.id
}