// This data source assumes there's already an image to create the launch config
data "aws_ami" "wp_web" {
  filter {
    name   = "name"
    values = [format("%s-*", var.name_prefix)]
  }

  owners = ["self"]
}

resource "aws_launch_configuration" "wp_web" {
  name                 = var.name_prefix
  image_id             = data.aws_ami.wp_web.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.wp_web.id
  security_groups      = [aws_security_group.web.id]

  user_data = <<EOF
#!/bin/bash
yum update -y
aws s3 sync --delete s3://${join(var.dl, [var.name_prefix, var.s3_bucket_names[0]])} /var/www/html
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wp_web" {
  name                 = var.name_prefix
  launch_configuration = aws_launch_configuration.wp_web.name

  min_size         = 2
  max_size         = 4
  desired_capacity = 3

  vpc_zone_identifier = [
    for key, subnet in aws_subnet.wp : subnet.id if split(var.dl, key)[1] == "public"
  ]
  target_group_arns = [aws_lb_target_group.wp.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 60

  lifecycle {
    create_before_destroy = true
  }
}