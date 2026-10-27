#trivy:ignore:AWS-0039 (HIGH): Cluster does not have secret encryption enabled.
#trivy:ignore:AWS-0040 (CRITICAL): Public cluster access is enabled.
#trivy:ignore:AWS-0041 (CRITICAL): Cluster allows access from a public CIDR: 0.0.0.0/0
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
    endpoint_public_access  = true

    subnet_ids = var.private_subnet_ids
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_cluster,
    aws_iam_role_policy_attachment.eks
  ]
}

#trivy:ignore:AWS-0038 (MEDIUM): Control plane API logging is not enabled.
# By default cluster control plane logging is not turned on. Logging is available for audit, api, authenticator, controllerManager and scheduler. All logging should be turned on for cluster control plane.

# EKS cluster resources should have the encryption_config block set with protection of the secrets resource.
# EKS clusters are available publicly by default, this should be explicitly disabled in the vpc_config of the EKS cluster resource.
# EKS Clusters have public access cidrs set to 0.0.0.0/0 by default which is wide open to the internet. This should be explicitly set to a more specific private CIDR range
