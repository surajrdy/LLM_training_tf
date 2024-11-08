# =========================================================
# Locals
# =========================================================

locals {
    notifications_topic_arn = var.notifications_topic_enabled ? var.notifications_topic_arn : aws_sns_topic.notifications[0].arn
}

# =========================================================
# Resources
# =========================================================

resource "aws_sns_topic" "notifications" {
    count = var.notifications_topic_enabled ? 0 : 1

    name = var.name

    tags = {
        DataClassification = "Sensitive"
    }
}
