provider "aws" {
  profile = var.profile
  region  = terraform.workspace != "default" ? terraform.workspace : "us-west-1"
}

locals {
  region_tag = lookup(var.regions, terraform.workspace, "sfo")
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  for_each = {
    for pair in setproduct(var.envs, keys(var.vpcs)) :
    "${pair[0]}-${pair[1]}" => var.vpcs[pair[1]]
  }

  cidr_block = each.value
  tags = {
    Name   = each.key
    env    = split("-", each.key)[0]
    region = local.region_tag
  }
}

resource "aws_subnet" "subnet" {
  for_each = {
    for pair in setproduct(keys(aws_vpc.vpc), keys(var.subnets)) :
    "${pair[0]}-${pair[1]}" => {
      vpc_id     = aws_vpc.vpc[pair[0]].id
      cidr_block = var.subnets[pair[1]]
    }
  }

  vpc_id            = each.value.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = data.aws_availability_zones.available.names[split("-", each.key)[2] == "public" ? 0 : 1]
  tags = {
    Name   = each.key
    env    = split("-", each.key)[0]
    region = local.region_tag
  }
}

resource "aws_internet_gateway" "igw" {
  for_each = aws_vpc.vpc

  vpc_id = each.value.id
  tags = {
    Name   = join("-", [each.key, "igw"])
    env    = split("-", each.key)[0]
    region = local.region_tag
  }
}

resource "aws_route_table" "private" {
  for_each = aws_vpc.vpc

  vpc_id = each.value.id
  tags = {
    Name   = join("-", [each.key, "rt", "private"])
    env    = split("-", each.key)[0]
    region = local.region_tag
  }
}

resource "aws_route_table" "public" {
  for_each = aws_vpc.vpc

  vpc_id = each.value.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }
  tags = {
    Name   = join("-", [each.key, "rt", "public"])
    env    = split("-", each.key)[0]
    region = local.region_tag
  }
}

resource "aws_main_route_table_association" "main" {
  for_each = aws_vpc.vpc

  vpc_id         = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each = aws_route_table.public

  route_table_id = each.value.id
  subnet_id      = aws_subnet.subnet[join("-", [each.key, "public"])].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_route_table.private

  route_table_id = each.value.id
  subnet_id      = aws_subnet.subnet[join("-", [each.key, "private"])].id
}