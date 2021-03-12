data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "ec2_s3_full_access" {
  name               = "ec2_full_access_to_s3"
  description        = "Grant EC2 instances full access to S3."
  assume_role_policy = file("ec2_sts_assume_role_policy.json")
  managed_policy_arns = [
    data.aws_iam_policy.AmazonS3FullAccess.arn,
  ]
}

resource "aws_iam_instance_profile" "wp_web" {
  role = aws_iam_role.ec2_s3_full_access.name
}