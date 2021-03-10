provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "vpc" {
  for_each   = var.envs
  cidr_block = "10.0.0.0/24"
  tags = {
    env = each.value
  }
}
