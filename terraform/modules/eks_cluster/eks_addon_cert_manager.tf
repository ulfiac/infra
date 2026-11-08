resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = aws_iam_role.eks_addon_cert_manager.arn

  depends_on = [
    aws_eks_addon.pod_identity
  ]
}

resource "aws_eks_addon" "cert_manager" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "cert-manager"
  addon_version = local.version_eks_addon_cert_manager

  tags = {
    Name = "cert-manager"
  }

  depends_on = [
    aws_eks_addon.pod_identity,
    aws_eks_pod_identity_association.cert_manager,
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
    aws_iam_role_policy_attachment.cert_manager_policy_to_eks_addon_cert_manager,
  ]
}
