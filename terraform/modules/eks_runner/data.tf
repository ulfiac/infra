data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_codestarconnections_connection" "github" {
  count = var.verify_github_connection ? 1 : 0

  arn = var.github_connection_arn
}

data "aws_iam_policy" "amazon_ec2_container_registry_read_only" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${local.aws_account_id}-${local.aws_region}"
}
