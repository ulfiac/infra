resource "aws_eks_access_entry" "admin" {
  for_each      = var.cluster_admin_role_arns
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = each.value
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "cluster_admin" {
  for_each      = aws_eks_access_entry.admin
  cluster_name  = each.value.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value.principal_arn

  access_scope {
    type = "cluster"
  }
}
