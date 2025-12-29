data "aws_caller_identity" "current" {}

data "aws_regions" "enabled" {}

data "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
}
