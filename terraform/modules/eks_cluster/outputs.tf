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

output "eks_addon_coredns_version" {
  description = "The version object for the EKS addon coredns (both default and latest)"
  value = var.verbose ? {
    default = data.aws_eks_addon_version.coredns_default
    latest  = data.aws_eks_addon_version.coredns_latest
  } : null
}

output "eks_addon_kube_proxy_version" {
  description = "The version object for the EKS addon kube proxy (both default and latest)"
  value = var.verbose ? {
    default = data.aws_eks_addon_version.kube_proxy_default
    latest  = data.aws_eks_addon_version.kube_proxy_latest
  } : null
}

output "eks_addon_pod_identity_version" {
  description = "The version object for the EKS addon pod identity (both default and latest)"
  value = var.verbose ? {
    default = data.aws_eks_addon_version.pod_identity_default
    latest  = data.aws_eks_addon_version.pod_identity_latest
  } : null
}

output "eks_addon_vpc_cni_version" {
  description = "The version object for the EKS addon vpc cni (both default and latest)"
  value = var.verbose ? {
    default = data.aws_eks_addon_version.vpc_cni_default
    latest  = data.aws_eks_addon_version.vpc_cni_latest
  } : null
}

output "versions" {
  description = "The version information for the EKS cluster and addons"
  value = {
    eks_addon_coredns = {
      "actual  " = length(aws_eks_addon.coredns.arn) > 0 ? aws_eks_addon.coredns.addon_version : null
      "default " = data.aws_eks_addon_version.coredns_default.version
      "latest  " = data.aws_eks_addon_version.coredns_latest.version
      "pinned  " = lookup(var.versions, "eks_addon_coredns", "not pinned")
    }
    eks_addon_kube_proxy = {
      "actual  " = length(aws_eks_addon.kube_proxy.arn) > 0 ? aws_eks_addon.kube_proxy.addon_version : null
      "default " = data.aws_eks_addon_version.kube_proxy_default.version
      "latest  " = data.aws_eks_addon_version.kube_proxy_latest.version
      "pinned  " = lookup(var.versions, "eks_addon_kube_proxy", "not pinned")
    }
    eks_addon_pod_identity = {
      "actual  " = length(aws_eks_addon.pod_identity.arn) > 0 ? aws_eks_addon.pod_identity.addon_version : null
      "default " = data.aws_eks_addon_version.pod_identity_default.version
      "latest  " = data.aws_eks_addon_version.pod_identity_latest.version
      "pinned  " = lookup(var.versions, "eks_addon_pod_identity", "not pinned")
    }
    eks_addon_vpc_cni = {
      "actual  " = length(aws_eks_addon.vpc_cni.arn) > 0 ? aws_eks_addon.vpc_cni.addon_version : null
      "default " = data.aws_eks_addon_version.vpc_cni_default.version
      "latest  " = data.aws_eks_addon_version.vpc_cni_latest.version
      "pinned  " = lookup(var.versions, "eks_addon_vpc_cni", "not pinned")
    }
    eks_cluster = {
      "actual  " = length(aws_eks_cluster.eks.arn) > 0 ? aws_eks_cluster.eks.version : null
      "default " = data.aws_eks_cluster_versions.default.cluster_versions[0].cluster_version
      "pinned  " = lookup(var.versions, "eks_cluster", "not pinned")
    }
  }
}
