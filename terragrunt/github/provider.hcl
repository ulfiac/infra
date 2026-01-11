locals {
  aws_account_id = get_env("TG_VAR_AWS_ACCOUNT_ID")
  aws_region     = "us-east-2"
  providers      = ["github"]
}
