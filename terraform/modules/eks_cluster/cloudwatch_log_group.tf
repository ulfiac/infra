resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${local.eks_cluster_name}/cluster"
  retention_in_days = 30
}
