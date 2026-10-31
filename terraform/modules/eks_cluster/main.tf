locals {
  aws_region = data.aws_region.current.region

  eks_cluster_name             = "eks-${var.eks_cluster_name}-${local.aws_region}"
  iam_role_name_eks_cluster    = "eks-${var.eks_cluster_name}-${local.aws_region}-cluster"
  iam_role_name_eks_node_group = "eks-${var.eks_cluster_name}-${local.aws_region}-node-group"
}
