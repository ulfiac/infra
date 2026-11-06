resource "aws_eks_addon" "metrics_server" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "metrics-server"
  addon_version = local.version_eks_addon_metrics_server

  tags = {
    Name = "metrics-server"
  }

  depends_on = [
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
  ]
}
