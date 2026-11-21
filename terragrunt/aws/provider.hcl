locals {
  aws_default_tags = {
    created_by = "terragrunt/terraform"
    repo       = "infra"
  }

  eks_cluster_name = "eks-blue-us-east-2"

  providers = ["aws"]
}
