locals {
  aws_account_id      = data.aws_caller_identity.current.account_id
  aws_regions_enabled = data.aws_regions.enabled.names

  athena_database_name         = "logs"                    # must be lowercase letters, numbers, or underscore
  athena_table_name_cloudtrail = "cloudtrail_multi_region" # should be lowercase letters, numbers, or underscore
  athena_workgroup_name        = "logs"

  log_bucket_name = data.aws_s3_bucket.logs.bucket
}
