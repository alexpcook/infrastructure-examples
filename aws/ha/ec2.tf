locals {
  public_subnets = {
    for key, subnet in aws_subnet.wp : key => subnet if split(var.dl, key)[1] == "public"
  }
  region = terraform.workspace == "default" ? "us-west-1" : terraform.workspace
}

resource "aws_instance" "wp_web" {
  for_each = local.public_subnets

  ami                  = var.web_ami_id[local.region]
  instance_type        = "t2.micro"
  subnet_id            = each.value.id
  security_groups      = [aws_security_group.web.id]
  key_name             = aws_key_pair.ssh_key.key_name
  iam_instance_profile = aws_iam_instance_profile.wp_web.id
  user_data            = file("ec2_wp_web_bootstrap.sh")

  tags = {
    Name = join(var.dl, [var.name_prefix, "web"])
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.name_prefix
  public_key = file("./.ssh/ec2.pub")
}