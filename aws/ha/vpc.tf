data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az = {
    primary   = data.aws_availability_zones.available.names[0]
    secondary = data.aws_availability_zones.available.names[1]
  }
}

resource "aws_vpc" "wp" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name_prefix
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = aws_vpc.wp.default_route_table_id

  tags = {
    Name = join(var.dl, [var.name_prefix, "private"])
  }
}

resource "aws_default_network_acl" "private" {
  default_network_acl_id = aws_vpc.wp.default_network_acl_id
  subnet_ids = [
    for az in keys(local.az) : aws_subnet.wp[join(var.dl, [az, "private"])].id
  ]

  tags = {
    Name = join(var.dl, [var.name_prefix, "private"])
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wp.id
  tags = {
    Name = join(var.dl, [var.name_prefix, "igw"])
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.wp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = join(var.dl, [var.name_prefix, "public"])
  }
}

resource "aws_route_table_association" "association" {
  for_each = aws_subnet.wp

  route_table_id = split(var.dl, each.key)[1] == "public" ? aws_route_table.public.id : aws_vpc.wp.default_route_table_id
  subnet_id      = each.value.id
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.wp.id
  subnet_ids = [
    for az in keys(local.az) : aws_subnet.wp[join(var.dl, [az, "public"])].id
  ]

  ingress = [{
    action          = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port       = 0
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null
    protocol        = "all"
    rule_no         = 100
    to_port         = 0
  }]

  egress = [{
    action          = "allow"
    cidr_block      = "0.0.0.0/0"
    from_port       = 0
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null
    protocol        = "all"
    rule_no         = 100
    to_port         = 0
  }]

  tags = {
    Name = join(var.dl, [var.name_prefix, "public"])
  }
}

resource "aws_subnet" "wp" {
  for_each = {
    for inx, val in setproduct(keys(local.az), ["public", "private"])
    : "${val[0]}-${val[1]}" => {
      cidr_block        = format(var.subnet_cidr_format_string, inx + 1)
      availability_zone = local.az[val[0]]
    }
  }

  vpc_id            = aws_vpc.wp.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = join(var.dl, [var.name_prefix, each.key])
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

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all outbound traffic"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "-1"
    security_groups  = null
    self             = false
    to_port          = 0
  }]
}

resource "aws_security_group" "db" {
  name        = join(var.dl, [var.name_prefix, "db"])
  description = "Allow MySQL from the web security group"
  vpc_id      = aws_vpc.wp.id

  ingress = [{
    cidr_blocks      = null
    description      = "Allow MySQL from the web security group"
    from_port        = 3306
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "tcp"
    security_groups  = [aws_security_group.web.id]
    self             = false
    to_port          = 3306
  }]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow all outbound traffic"
    from_port        = 0
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    protocol         = "-1"
    security_groups  = null
    self             = false
    to_port          = 0
  }]
}