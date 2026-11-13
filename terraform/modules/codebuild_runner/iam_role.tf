data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild_runner" {
  name               = local.name_iam_role_codebuild_runner
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "administrator_access_to_codebuild_runner" {
  role       = aws_iam_role.codebuild_runner.name
  policy_arn = data.aws_iam_policy.administrator_access_policy.arn
}
