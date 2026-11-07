variable "cluster_admin_role_names" {
  default     = ["role-switch-admin"]
  description = "The names of the IAM roles that should have cluster admin access"
  type        = set(string)
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string

  validation {
    condition     = length(var.eks_cluster_name) <= 20
    error_message = "The EKS cluster name must not be more than 20 characters"
  }
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets for the EKS cluster"
  type        = list(string)
}

variable "verbose" {
  default     = false
  description = "Enable verbose output"
  type        = bool
}

variable "versions" {
  default     = {}
  description = "The versions of various EKS components"
  type        = map(string)

  # Clusters older than 1.28 do not envelope encrypt Kubernetes API data by default
  # https://docs.aws.amazon.com/eks/latest/userguide/envelope-encryption.html
  validation {
    condition = !contains(keys(var.versions), "eks_cluster") || try(
      tonumber(regex("^1\\.(\\d+)$", var.versions["eks_cluster"])[0]) >= 28,
      false
    )
    error_message = "If versions[\"eks_cluster\"] is pinned, it must be in the form \"1.NN\" and be 1.28 or newer."
  }
}
