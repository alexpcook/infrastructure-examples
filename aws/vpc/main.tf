provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "vpc" {
  for_each   = var.network
  cidr_block = each.key
}
