data "aws_iam_policy_document" "eks_addon_ebs_csi_driver_assume_role_policy" {
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
      values   = ["ebs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_role" "eks_addon_ebs_csi_driver" {
  name               = local.iam_role_name_eks_addon_ebs_csi_driver
  assume_role_policy = data.aws_iam_policy_document.eks_addon_ebs_csi_driver_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver_policy_to_eks_addon_ebs_csi_driver" {
  policy_arn = data.aws_iam_policy.amazon_ebs_csi_driver_policy.arn
  role       = aws_iam_role.eks_addon_ebs_csi_driver.name
}
