resource "aws_notifications_notification_configuration" "cloudwatch_alarms_from_cloudtrail" {
  name                 = local.user_notifications_notification_configuration_name
  description          = "Push notification when the Cloudwatch alarms related to Cloudtrail fire."
  aggregation_duration = "NONE"
}

resource "aws_notifications_event_rule" "cloudwatch_alarms_from_cloudtrail" {
  event_type                     = "CloudWatch Alarm State Change"
  notification_configuration_arn = aws_notifications_notification_configuration.cloudwatch_alarms_from_cloudtrail.arn
  regions                        = [local.aws_region]
  source                         = "aws.cloudwatch"

  event_pattern = jsonencode({
    detail = {
      alarmName = [
        aws_cloudwatch_metric_alarm.console_login_without_mfa.alarm_name,
        aws_cloudwatch_metric_alarm.root_user_activity.alarm_name,
      ]
      state = { value = ["ALARM"] }
    }
  })
}
