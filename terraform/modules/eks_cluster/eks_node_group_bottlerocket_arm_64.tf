resource "aws_eks_node_group" "bottlerocket_arm_64" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "bottlerocket_arm_64"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  release_version = nonsensitive(data.aws_ssm_parameter.bottlerocket_arm_64_image_version.value)
  subnet_ids      = var.private_subnet_ids
  version         = local.version_eks_node_group

  ami_type       = "BOTTLEROCKET_ARM_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t4g.large"]

  labels = {
    role = "bottlerocket_arm_64"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  scaling_config {
    desired_size = 2
    max_size     = 10
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_addon.pod_identity,
    aws_eks_addon.vpc_cni,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only_policy_to_eks_node_group,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_to_eks_node_group,
  ]
}
