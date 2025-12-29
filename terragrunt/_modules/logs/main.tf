locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  cloudtrail_name = "multi-region-trail-${local.aws_account_id}-${local.aws_region}"

  cloudwatch_log_group_name = "/aws/cloudtrail/${local.cloudtrail_name}"

  iam_policy_name_cloudtrail_to_cloudwatch = "cloudtrail-to-cloudwatch-new"
  iam_role_name_cloudtrail_to_cloudwatch   = "cloudtrail-to-cloudwatch-new"

  s3_bucket_name = "logs-${local.aws_account_id}-${local.aws_region}"

  s3_key_prefixes = {
    alb = {
      expiration_days      = var.expire_alb_logs_in_days
      expiration_id        = "expire_alb_logs"
      prefix_with_slash    = "alb/"
      prefix_without_slash = "alb"
    },
    athena = {
      expiration_days      = var.expire_athena_results_in_days
      expiration_id        = "expire_athena_results"
      prefix_with_slash    = "athena/"
      prefix_without_slash = "athena"
    },
    cloudtrail = {
      expiration_days      = var.expire_cloudtrail_logs_in_days
      expiration_id        = "expire_cloudtrail_logs"
      prefix_with_slash    = "cloudtrail/"
      prefix_without_slash = "cloudtrail"
    },
    nlb = {
      expiration_days      = var.expire_nlb_logs_in_days
      expiration_id        = "expire_nlb_logs"
      prefix_with_slash    = "nlb/"
      prefix_without_slash = "nlb"
    },
    route53 = {
      expiration_days      = var.expire_route53_logs_in_days
      expiration_id        = "expire_route53_logs"
      prefix_with_slash    = "route53/"
      prefix_without_slash = "route53"
    },
    vpcflow = {
      expiration_days      = var.expire_vpc_flow_logs_in_days
      expiration_id        = "expire_vpc_flow_logs"
      prefix_with_slash    = "vpcflow/"
      prefix_without_slash = "vpcflow"
    },
  }
}
