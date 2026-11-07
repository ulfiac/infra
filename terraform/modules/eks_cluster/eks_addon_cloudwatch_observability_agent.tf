resource "aws_eks_addon" "cloudwatch_observability_agent" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "amazon-cloudwatch-observability"
  addon_version = local.version_eks_addon_cloudwatch_observability_agent

  pod_identity_association {
    role_arn        = aws_iam_role.eks_addon_cloudwatch_observability.arn
    service_account = "cloudwatch-agent"
  }

  tags = {
    Name = "cloudwatch-observability-agent"
  }

  depends_on = [
    aws_eks_addon.pod_identity,
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
    aws_iam_role_policy_attachment.cloudwatch_agent_server_policy_to_eks_addon_cloudwatch_observability_agent,
  ]
}
