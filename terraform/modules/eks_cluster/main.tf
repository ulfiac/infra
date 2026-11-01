locals {
  aws_region = data.aws_region.current.region

  eks_cluster_name             = "eks-${var.eks_cluster_name}-${local.aws_region}"
  iam_role_name_eks_cluster    = "eks-${var.eks_cluster_name}-${local.aws_region}-cluster"
  iam_role_name_eks_node_group = "eks-${var.eks_cluster_name}-${local.aws_region}-node-group"

  version_eks_addon_pod_identity = lookup(var.versions, "eks_addon_pod_identity", data.aws_eks_addon_version.pod_identity_default.version)
  version_eks_cluster            = lookup(var.versions, "eks_cluster", data.aws_eks_cluster_versions.default.cluster_versions[0].cluster_version)
  version_eks_node_group         = lookup(var.versions, "eks_node_group", aws_eks_cluster.eks.version)
}
