data "aws_eks_cluster_versions" "default" {
  default_only = true
}

data "aws_eks_addon_version" "pod_identity_default" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.eks.version
  most_recent        = false
}

data "aws_eks_addon_version" "pod_identity_latest" {
  addon_name         = "eks-pod-identity-agent"
  kubernetes_version = aws_eks_cluster.eks.version
  most_recent        = true
}

data "aws_iam_policy" "amazon_ec2_container_registry_read_only" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy" "amazon_eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "amazon_eks_cni_policy" {
  name = "AmazonEKS_CNI_Policy"
}

data "aws_iam_policy" "amazon_eks_worker_node_policy" {
  name = "AmazonEKSWorkerNodePolicy"
}

data "aws_iam_role" "cluster_admin" {
  for_each = var.cluster_admin_role_names
  name     = each.value
}

data "aws_region" "current" {}

