locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  cloudwatch_log_metric_filter_name_console_login_without_mfa = "console-login-without-mfa"
  cloudwatch_log_metric_filter_name_kms_key_deletion          = "kms-key-deletion"
  cloudwatch_log_metric_filter_name_root_user                 = "root-user-activity"

  cloudwatch_metric_alarm_name_console_login_without_mfa = "console-login-without-mfa"
  cloudwatch_metric_alarm_name_kms_key_deletion          = "kms-key-deletion"
  cloudwatch_metric_alarm_name_root_user                 = "root-user-activity"

  sns_topic_name = "cloudwatch-alarms"
}
