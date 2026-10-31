data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster" {
  name               = local.iam_role_name_eks_cluster
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = data.aws_iam_policy.amazon_eks_cluster_policy.arn
  role       = aws_iam_role.eks_cluster.name
}
