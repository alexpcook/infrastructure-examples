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

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow HTTP from the Internet"
    from_port        = 80
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 80
    }, {
    cidr_blocks      = [format("%s/32", var.my_public_ip)]
    description      = "Allow SSH from my public IP"
    from_port        = 22
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = null
    self             = false
    to_port          = 22
  }]
}

resource "aws_security_group" "db" {
  name        = join(var.dl, [var.name_prefix, "db"])
  description = "Allow MySQL from the web security group"
  vpc_id      = aws_vpc.wp.id
}