resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name  = aws_eks_cluster.eks.name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = local.version_eks_addon_ebs_csi_driver

  pod_identity_association {
    role_arn        = aws_iam_role.eks_addon_ebs_csi_driver.arn
    service_account = "ebs-csi-controller-sa"
  }

  tags = {
    Name = "ebs-csi-driver"
  }

  depends_on = [
    aws_eks_addon.pod_identity,
    aws_eks_node_group.bottlerocket_arm_64,
    aws_eks_node_group.bottlerocket_x86_64,
    aws_iam_role_policy_attachment.amazon_ebs_csi_driver_policy_to_eks_addon_ebs_csi_driver,
  ]
}
