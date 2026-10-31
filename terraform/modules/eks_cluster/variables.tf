variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets for the EKS cluster"
  type        = list(string)
}

variable "cluster_admin_role_names" {
  default     = ["role-switch-admin"]
  description = "The names of the IAM roles that should have cluster admin access"
  type        = set(string)
}
