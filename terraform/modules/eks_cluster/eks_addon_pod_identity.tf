resource "aws_eks_addon" "pod_identity" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = local.version_eks_addon_pod_identity

  depends_on = [
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
  ]

  tags = {
    Name = "eks-pod-identity-agent"
  }
}
