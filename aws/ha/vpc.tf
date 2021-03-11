resource "aws_vpc" "wp" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "wordpress-network"
  }
}

resource "aws_security_group" "web" {
  name        = join(var.dl, [var.name_prefix, "web"])
  description = "Allow SSH from my public IP and HTTP from the Internet"
  vpc_id      = aws_vpc.wp.id
}

resource "aws_security_group" "db" {
  name        = join(var.dl, [var.name_prefix, "db"])
  description = "Allow MySQL from the web security group"
  vpc_id      = aws_vpc.wp.id
}