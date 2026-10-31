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
