output "bucket_name" {
  description = "The name of the logs S3 bucket"
  value       = aws_s3_bucket.logs.bucket
}

output "key_prefixes" {
  description = "The S3 key prefixes for different log types"
  value       = { for k, v in local.s3_key_prefixes : k => v.prefix_without_slash }
}

output "log_group_name" {
  description = "The name of the CloudWatch log group for CloudTrail"
  value       = aws_cloudwatch_log_group.cloudtrail.name
}
