provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "vpc" {
  for_each = {
    for pair in setproduct(var.envs, keys(var.vpcs)) : "${pair[0]}-${pair[1]}" => var.vpcs[pair[1]]
  }

  cidr_block = each.value
  tags = {
    env = each.key
  }
}
