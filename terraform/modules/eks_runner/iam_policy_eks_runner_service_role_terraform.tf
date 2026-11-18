data "aws_iam_policy_document" "eks_runner_service_role_terraform" {
  statement {
    sid    = "EKSClusterDiscovery"
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
    ]
    resources = ["arn:aws:eks:*:*:cluster/*"]
  }

  statement {
    sid    = "EKSClusterList"
    effect = "Allow"
    actions = [
      "eks:ListClusters",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "StsTokenGeneration"
    effect = "Allow"
    actions = [
      "sts:GetCallerIdentity",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "TerraformStateS3"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = ["${data.aws_s3_bucket.terraform_state.arn}/*"]
  }

  statement {
    sid       = "TerraformStateS3List"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [data.aws_s3_bucket.terraform_state.arn]
  }
}

resource "aws_iam_policy" "eks_runner_service_role_terraform" {
  name   = local.name_iam_policy_service_role_terraform
  policy = data.aws_iam_policy_document.eks_runner_service_role_terraform.json
}
