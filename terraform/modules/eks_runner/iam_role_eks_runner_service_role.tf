data "aws_iam_policy_document" "codebuild_runner_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }
  }
}

resource "aws_iam_role" "eks_runner_service_role" {
  name               = local.name_iam_role_service_role
  assume_role_policy = data.aws_iam_policy_document.codebuild_runner_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_runner_service_role" {
  role       = aws_iam_role.eks_runner_service_role.name
  policy_arn = aws_iam_policy.eks_runner_service_role.arn
}

resource "aws_iam_role_policy_attachment" "eks_runner_service_role_ecr" {
  role       = aws_iam_role.eks_runner_service_role.name
  policy_arn = data.aws_iam_policy.amazon_ec2_container_registry_read_only.arn
}

resource "aws_iam_role_policy_attachment" "eks_runner_service_role_terraform" {
  role       = aws_iam_role.eks_runner_service_role.name
  policy_arn = aws_iam_policy.eks_runner_service_role_terraform.arn
}
