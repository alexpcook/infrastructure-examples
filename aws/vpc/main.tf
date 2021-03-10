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
