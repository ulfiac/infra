data "aws_iam_policy_document" "eks_addon_cert_manager_assume_role_policy" {
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
      values   = ["cert-manager"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes-service-account"
      values   = ["cert-manager"]
    }
  }
}

resource "aws_iam_role" "eks_addon_cert_manager" {
  name               = local.name_iam_role_eks_addon_cert_manager
  assume_role_policy = data.aws_iam_policy_document.eks_addon_cert_manager_assume_role_policy.json
}

data "aws_iam_policy_document" "cert_manager" {
  statement {
    actions   = ["route53:GetChange"]
    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    actions   = ["route53:ListResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  # DNS-01 challenges only need to create/delete TXT records named _acme-challenge.<domain>
  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
    condition {
      test     = "ForAllValues:StringEquals"
      variable = "route53:ChangeResourceRecordSetsRecordTypes"
      values   = ["TXT"]
    }
    condition {
      test     = "ForAllValues:StringLike"
      variable = "route53:ChangeResourceRecordSetsNormalizedRecordNames"
      values   = ["_acme-challenge.*"]
    }
  }

  statement {
    actions   = ["route53:ListHostedZonesByName"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cert_manager_policy" {
  policy = data.aws_iam_policy_document.cert_manager.json
  name   = local.name_iam_policy_eks_addon_cert_manager
}

resource "aws_iam_role_policy_attachment" "cert_manager_policy_to_eks_addon_cert_manager" {
  policy_arn = aws_iam_policy.cert_manager_policy.arn
  role       = aws_iam_role.eks_addon_cert_manager.name
}
