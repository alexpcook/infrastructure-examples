provider "aws" {
  profile = var.profile
  region  = terraform.workspace == "default" ? "us-east-1" : terraform.workspace
}

locals {
  region_tag = lookup(var.regions, terraform.workspace, "unk")
}

resource "aws_vpc" "vpc" {
  for_each = {
    for pair in setproduct(var.envs, keys(var.vpcs)) : "${pair[0]}-${pair[1]}" => var.vpcs[pair[1]]
  }

  cidr_block = each.value
  tags = {
    name = join("-", [local.region_tag, each.key])
  }
}

resource "aws_subnet" "subnet" {
  for_each = {
    for combo in setproduct(var.envs, keys(var.vpcs), keys(var.subnets)) :
    "${combo[0]}-${combo[1]}-${combo[2]}" => {
      vpc_id     = aws_vpc.vpc[join("-", [combo[0], combo[1]])].id,
      cidr_block = join("", [trimsuffix(var.vpcs[combo[1]], "0/24"), var.subnets[combo[2]]]),
    }
  }

  vpc_id     = each.value.vpc_id
  cidr_block = each.value.cidr_block
  tags = {
    name = each.key
  }
}
