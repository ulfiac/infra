data "aws_caller_identity" "current" {}

data "aws_iam_policy" "amazon_ec2_container_registry_read_only" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}
