#trivy:ignore:AWS-0039 (HIGH): Cluster does not have secret encryption enabled.
resource "aws_eks_cluster" "eks" {
  name                          = local.eks_cluster_name
  bootstrap_self_managed_addons = true
  deletion_protection           = false
  enabled_cluster_log_types     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  role_arn                      = aws_iam_role.eks.arn
  version                       = var.eks_version

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false

    subnet_ids = var.private_subnet_ids
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.eks
  ]
}
