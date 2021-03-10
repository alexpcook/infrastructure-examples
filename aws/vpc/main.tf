provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "vpc" {
  for_each   = var.vpcs
  cidr_block = each.value
  tags = {
    name = each.key
  }
}
