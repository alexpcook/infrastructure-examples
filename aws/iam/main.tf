### TODO ###
# 2. Add IAMUserChangePassword policy to aws_iam_user.
# 3. Create a role granting full S3 access to EC2 instances.
# 4. Create CloudWatch billing alarm with SNS alert.

provider "aws" {
  region = var.region
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
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

resource "aws_iam_group_policy_attachment" "group_policy" {
  group      = aws_iam_group.group.name
  policy_arn = data.aws_iam_policy.AdministratorAccess.arn
}
