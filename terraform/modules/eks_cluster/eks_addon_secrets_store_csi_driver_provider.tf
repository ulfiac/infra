resource "aws_eks_addon" "secrets_store_csi_driver_provider" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "aws-secrets-store-csi-driver-provider"
  addon_version = local.version_eks_addon_secrets_store_csi_driver_provider

  pod_identity_association {
    role_arn        = aws_iam_role.eks_addon_secrets_store_csi_driver_provider.arn
    service_account = "csi-secrets-store-provider-aws"
  }

  tags = {
    Name = "secrets-store-csi-driver-provider"
  }

  depends_on = [
    aws_eks_addon.pod_identity,
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
    aws_iam_role_policy_attachment.aws_secrets_manager_client_read_only_access_policy_to_eks_addon_secrets_store_csi_driver_provider,
  ]
}
