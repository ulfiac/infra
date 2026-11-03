resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "vpc-cni"
  addon_version = local.version_eks_addon_vpc_cni

  pod_identity_association {
    role_arn        = aws_iam_role.eks_addon_vpc_cni.arn
    service_account = "aws-node"
  }

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = {
    Name = "vpc-cni"
  }

  depends_on = [
    aws_eks_addon.pod_identity,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_to_eks_addon_vpc_cni,
  ]
}
