locals {
  aws_default_tags = {
    created_by = "terragrunt/terraform"
    repo       = "infra"
  }

  email_sns = get_env("TG_VAR_EMAIL_SNS")
  providers = ["aws"]
}
