resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${local.name_eks_cluster}/cluster"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "cloudwatch_observability_agent" {
  for_each = toset([
    "/aws/containerinsights/${local.name_eks_cluster}/application",
    "/aws/containerinsights/${local.name_eks_cluster}/dataplane",
    "/aws/containerinsights/${local.name_eks_cluster}/host",
    "/aws/containerinsights/${local.name_eks_cluster}/performance"
  ])

  name              = each.value
  retention_in_days = 30
}
