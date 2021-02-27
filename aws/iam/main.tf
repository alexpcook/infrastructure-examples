provider "aws" {
  region = var.region
}

### Managed IAM policies ###
data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "IAMUserChangePassword" {
  arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

### IAM user/policy ###
resource "aws_iam_user" "user" {
  name = var.users[0]
  path = var.path
}

resource "aws_iam_user_policy_attachment" "user_policy" {
  user       = aws_iam_user.user.name
  policy_arn = data.aws_iam_policy.IAMUserChangePassword.arn
}

resource "aws_iam_user_login_profile" "user_profile" {
  user    = aws_iam_user.user.name
  pgp_key = var.pgp_key
}

### IAM group/membership/policy ####
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

### IAM role ###
resource "aws_iam_role" "role" {
  name               = "ec2_full_access_to_s3"
  description        = "Grant EC2 instances full access to S3."
  path               = var.path
  assume_role_policy = file(var.ec2_sts_assume_role_policy_json)
  managed_policy_arns = [
    data.aws_iam_policy.AmazonS3FullAccess.arn,
  ]
}

### Output ###
output "password" {
  value = aws_iam_user_login_profile.user_profile.encrypted_password
}
