provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "user" {
  name = "user1"
  tags = {
    created-by-tf = "true"
  }
}

resource "aws_iam_group" "group" {
  name = "my-users"
}

resource "aws_iam_group_membership" "team" {
  name = "my-users-membership"

  users = [
    aws_iam_user.user.name,
  ]

  group = aws_iam_group.group.name
}
