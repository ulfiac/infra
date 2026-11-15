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

resource "aws_iam_role" "codebuild_runner" {
  name               = local.name_iam_role_codebuild_runner
  assume_role_policy = data.aws_iam_policy_document.codebuild_runner_assume_role.json
}

data "aws_iam_policy_document" "codebuild_runner" {
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:${local.aws_account_id}:log-group:/aws/codebuild/*"]
  }

  statement {
    sid    = "CodeBuildReports"
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages",
    ]
    resources = ["arn:aws:codebuild:*:${local.aws_account_id}:report-group/*"]
  }

  statement {
    sid    = "CodeConnectionsAccess"
    effect = "Allow"
    actions = [
      "codeconnections:GetConnection",
      "codeconnections:GetConnectionToken",
      "codeconnections:UseConnection",
      "codestar-connections:GetConnection",
      "codestar-connections:GetConnectionToken",
      "codestar-connections:UseConnection",
    ]
    resources = [var.github_connection_arn]
  }

  statement {
    sid    = "VpcNetworking"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "CreateNetworkInterfacePermission"
    effect    = "Allow"
    actions   = ["ec2:CreateNetworkInterfacePermission"]
    resources = ["arn:aws:ec2:*:${local.aws_account_id}:network-interface/*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "codebuild_runner" {
  name   = local.name_iam_policy_codebuild_runner
  policy = data.aws_iam_policy_document.codebuild_runner.json
}

resource "aws_iam_role_policy_attachment" "codebuild_runner" {
  role       = aws_iam_role.codebuild_runner.name
  policy_arn = aws_iam_policy.codebuild_runner.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_runner_ecr" {
  role       = aws_iam_role.codebuild_runner.name
  policy_arn = data.aws_iam_policy.amazon_ec2_container_registry_read_only.arn
}
