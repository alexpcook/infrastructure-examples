provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "3.9.0"
}

resource "aws_iam_user" "user" {
  name = "user1"
  tags = {
    created-by-tf = "true"
  }
}
