provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/24"
}
