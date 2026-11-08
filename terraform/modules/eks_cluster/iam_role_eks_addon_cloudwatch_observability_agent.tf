data "aws_iam_policy_document" "eks_addon_cloudwatch_observability_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks-cluster-arn"
      values   = [aws_eks_cluster.eks.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-namespace"
      values   = ["amazon-cloudwatch"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = ["cloudwatch-agent"]
    }
  }
}

resource "aws_iam_role" "eks_addon_cloudwatch_observability" {
  name               = local.name_iam_role_eks_addon_cloudwatch_observability_agent
  assume_role_policy = data.aws_iam_policy_document.eks_addon_cloudwatch_observability_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_server_policy_to_eks_addon_cloudwatch_observability_agent" {
  policy_arn = data.aws_iam_policy.cloudwatch_agent_server_policy.arn
  role       = aws_iam_role.eks_addon_cloudwatch_observability.name
}
