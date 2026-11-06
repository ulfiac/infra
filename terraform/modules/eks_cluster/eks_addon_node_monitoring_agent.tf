resource "aws_eks_addon" "node_monitoring_agent" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "eks-node-monitoring-agent"
  addon_version = local.version_eks_addon_node_monitoring_agent

  tags = {
    Name = "eks-node-monitoring-agent"
  }

  depends_on = [
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
  ]
}
