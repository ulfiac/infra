data "aws_iam_policy_document" "app_access" {

  # https://docs.aws.amazon.com/consolemobileapp/latest/userguide/managing-notifications.html
  # https://docs.aws.amazon.com/consolemobileapp/latest/userguide/permissions-policies.html
  # https://docs.aws.amazon.com/notifications/latest/userguide/resource-level-permissions.html

  statement {
    sid    = "ViewUserNotifications"
    effect = "Allow"
    actions = [
      "notifications:GetEventRule",
      "notifications:GetNotificationConfiguration",
      "notifications:GetNotificationEvent",
      "notifications:ListChannels",
      "notifications:ListEventRules",
      "notifications:ListNotificationConfigurations",
      "notifications:ListNotificationEvents",
      "notifications:ListNotificationHubs",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ViewOwnMobileDevice"
    effect = "Allow"
    actions = [
      "consoleapp:GetDeviceIdentity",
      "consoleapp:ListDeviceIdentities",
    ]
    resources = ["*"]
  }

  # subscribing/unsubscribing the mobile device from a notification configuration associates/disassociates it as a delivery channel
  statement {
    sid    = "SubscribeToNotificationConfigurations"
    effect = "Allow"
    actions = [
      "notifications:AssociateChannel",
      "notifications:DisassociateChannel",
    ]
    resources = ["arn:aws:notifications::${local.aws_account_id}:configuration/*"]
  }

  # read-only access to alarms, metrics, and dashboards; intentionally excludes CloudWatch Logs (log contents)
  statement {
    sid    = "ViewCloudWatchAlarmsAndMetrics"
    effect = "Allow"
    actions = [
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetDashboard",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListDashboards",
      "cloudwatch:ListMetrics",
    ]
    resources = ["*"]
  }

  # the app's Cost Management widget uses the Cost Explorer API (charged per request)
  statement {
    sid    = "ViewCosts"
    effect = "Allow"
    actions = [
      "ce:GetCostAndUsage",
      "ce:GetCostForecast",
      "ce:GetDimensionValues",
      "ce:GetTags",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "app_access" {
  name        = var.policy_name_app_access
  description = "Allows the mobile user to receive push notifications and view CloudWatch alarms and costs in the AWS Console Mobile App."
  policy      = data.aws_iam_policy_document.app_access.json
}

resource "aws_iam_group_policy_attachment" "app_access" {
  group      = aws_iam_group.mobile_user.name
  policy_arn = aws_iam_policy.app_access.arn
}
