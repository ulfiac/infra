output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster" {
  description = "The EKS cluster object"
  value       = var.verbose ? aws_eks_cluster.eks : null
}

output "eks_cluster_version_default" {
  description = "The EKS cluster default version object"
  value       = var.verbose ? data.aws_eks_cluster_versions.default : null
}

output "eks_addon_pod_identity_version" {
  description = "The version object for the EKS addon pod identity (both default and latest)"
  value = var.verbose ? {
    default = data.aws_eks_addon_version.pod_identity_default
    latest  = data.aws_eks_addon_version.pod_identity_latest
  } : null
}

output "versions" {
  description = "The version information for the EKS cluster and addons"
  value = {
    eks_addon_pod_identity = {
      "actual  " = length(aws_eks_addon.pod_identity.arn) > 0 ? aws_eks_addon.pod_identity.addon_version : null
      "default " = data.aws_eks_addon_version.pod_identity_default.version
      "latest  " = data.aws_eks_addon_version.pod_identity_latest.version
      "pinned  " = lookup(var.versions, "eks_addon_pod_identity", "not pinned")
    }
    eks_cluster = {
      "actual  " = length(aws_eks_cluster.eks.arn) > 0 ? aws_eks_cluster.eks.version : null
      "default " = data.aws_eks_cluster_versions.default.cluster_versions[0].cluster_version
      "pinned  " = lookup(var.versions, "eks_cluster", "not pinned")
    }
  }
}
