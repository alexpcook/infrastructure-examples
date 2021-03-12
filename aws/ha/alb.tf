resource "aws_lb" "wp" {
  name               = var.name_prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets = [
    for key, subnet in aws_subnet.wp : subnet.id if split(var.dl, key)[1] == "public"
  ]

  tags = {
    Name = var.name_prefix
  }
}

resource "aws_lb_target_group" "wp" {
  name        = join(var.dl, [var.name_prefix, "web"])
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.wp.id
  target_type = "instance"

  health_check {
    enabled  = true
    port     = 80
    protocol = "HTTP"
    path     = "/healthy.html"

    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 6
  }
}