provider "aws" {
  profile = var.profile
  region  = terraform.workspace == "default" ? "us-east-1" : terraform.workspace
}

locals {
  region_id = lookup(var.regions, terraform.workspace, "unk")
}

resource "aws_vpc" "vpc" {
  for_each = {
    for pair in setproduct(var.envs, keys(var.vpcs)) : "${pair[0]}-${pair[1]}" => var.vpcs[pair[1]]
  }

  cidr_block = each.value
  tags = {
    env = join("-", [local.region_id, each.key])
  }
}
