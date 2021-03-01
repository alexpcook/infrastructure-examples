provider "aws" {
  region = var.region
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

// Existing NotifyMe topic imported into Terraform
resource "aws_sns_topic" "sns" {
}
