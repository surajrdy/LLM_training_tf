resource "aws_sns_topic" "omni-wt-cw-error-notification" {
  name = "omni-wt-cw-integration-error-notification-${var.env}"
}

resource "aws_sns_topic_subscription" "omni_wt_cw_emails" {
  for_each  = { for idx, email in var.omni_wt_cw_emails : idx => email }
  topic_arn = aws_sns_topic.omni-wt-cw-error-notification.arn
  protocol  = "email"
  endpoint  = each.value
}
