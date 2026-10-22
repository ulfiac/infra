locals {}

resource "aws_notifications_notification_hub" "hub" {
  notification_hub_region = "us-east-2"
}
