locals {
  aws_region = data.aws_region.current.region

  eks_cluster_name = "eks-${var.eks_cluster_name}-${local.aws_region}"
  iam_role_name    = "eks-${var.eks_cluster_name}-${local.aws_region}"
}
