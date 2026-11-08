data "aws_iam_policy_document" "eks_addon_secrets_store_csi_driver_provider_policy" {
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
      values   = ["csi-secrets-store-provider-aws"]
    }
  }
}

resource "aws_iam_role" "eks_addon_secrets_store_csi_driver_provider" {
  name               = local.iam_role_name_eks_addon_secrets_store_csi_driver_provider
  assume_role_policy = data.aws_iam_policy_document.eks_addon_secrets_store_csi_driver_provider_policy.json
}

resource "aws_iam_role_policy_attachment" "aws_secrets_manager_client_read_only_access_policy_to_eks_addon_secrets_store_csi_driver_provider" {
  policy_arn = data.aws_iam_policy.aws_secrets_manager_client_read_only_access_policy.arn
  role       = aws_iam_role.eks_addon_secrets_store_csi_driver_provider.name
}
