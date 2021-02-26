### TODO ###
# 4. Create CloudWatch billing alarm with SNS alert.

provider "aws" {
  region = var.region
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "IAMUserChangePassword" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "user" {
  name = var.users[0]
  path = var.path
}

resource "aws_iam_group" "group" {
  name = var.groups[0]
  path = var.path
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

resource "aws_iam_user_policy_attachment" "user_policy" {
  user       = aws_iam_user.user.name
  policy_arn = data.aws_iam_policy.IAMUserChangePassword.arn
}

resource "aws_iam_role" "role" {
  name        = "ec2_full_access_to_s3"
  description = "Grant EC2 instances full access to S3."
  path        = var.path

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn]
}
