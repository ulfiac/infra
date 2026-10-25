data "aws_iam_policy" "amazon_eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_region" "current" {}
