resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "vpc-cni"
  addon_version = local.version_eks_addon_vpc_cni

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  depends_on = [
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
  ]

  tags = {
    Name = "vpc-cni"
  }
}
