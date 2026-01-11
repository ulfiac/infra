locals {
  aws_account_name = "mgmt"
  aws_account_id   = get_env("TG_VAR_AWS_ACCOUNT_ID")
  aws_default_tags = {}

  source_version = "main"
}
