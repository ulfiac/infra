locals {
  providers = ["aws"]

  email_sns = get_env("TG_VAR_EMAIL_SNS")
}
