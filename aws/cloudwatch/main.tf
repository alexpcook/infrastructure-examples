provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "aws_cloudwatch_metric_alarm" "total_cost" {
  alarm_name        = "${var.name_prefix}-costs-exceed-20-usd"
  alarm_description = "Send message to SNS topic when costs exceed $20"

  namespace           = "AWS/Billing"
  metric_name         = "EstimatedCharges"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "20"
  dimensions = {
    Currency = "USD"
  }

  evaluation_periods = "1"
  period             = "21600"
  statistic          = "Maximum"

  alarm_actions = [aws_sns_topic.sns.arn]
}

resource "aws_sns_topic" "sns" {
  name_prefix  = var.name_prefix
  display_name = "${var.name_prefix}-total-costs"
}

resource "aws_sns_topic_subscription" "sub" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.email_address
}
