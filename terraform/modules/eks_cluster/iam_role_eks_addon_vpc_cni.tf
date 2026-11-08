data "aws_iam_policy_document" "eks_addon_vpc_cni_assume_role_policy" {
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
      values   = ["kube-system"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = ["aws-node"]
    }
  }
}

resource "aws_iam_role" "eks_addon_vpc_cni" {
  name               = local.name_iam_role_eks_addon_vpc_cni
  assume_role_policy = data.aws_iam_policy_document.eks_addon_vpc_cni_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_to_eks_addon_vpc_cni" {
  policy_arn = data.aws_iam_policy.amazon_eks_cni_policy.arn
  role       = aws_iam_role.eks_addon_vpc_cni.name
}
