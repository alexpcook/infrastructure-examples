### TODO ###
# 1. Add AdministratorAccess policy to aws_iam_group.
# 2. Add IAMUserChangePassword policy to aws_iam_user.
# 3. Create a role granting full S3 access to EC2 instances.
# 4. Create CloudWatch billing alarm with SNS alert.

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "user" {
  name = var.users[0]
  path = "/acg/"
}

resource "aws_iam_group" "group" {
  name = var.groups[0]
  path = "/acg/"
}

resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.user.name
  groups = [
    aws_iam_group.group.name,
  ]
}
