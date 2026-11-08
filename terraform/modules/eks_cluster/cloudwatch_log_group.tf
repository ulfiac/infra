resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${local.eks_cluster_name}/cluster"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "cloudwatch_observability_agent" {
  for_each = toset([
    "/aws/containerinsights/${local.eks_cluster_name}/application",
    "/aws/containerinsights/${local.eks_cluster_name}/dataplane",
    "/aws/containerinsights/${local.eks_cluster_name}/host",
    "/aws/containerinsights/${local.eks_cluster_name}/performance"
  ])

  name              = each.value
  retention_in_days = 30
}
