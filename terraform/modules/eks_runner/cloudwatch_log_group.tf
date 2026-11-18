resource "aws_cloudwatch_log_group" "eks_runner" {
  name              = "/aws/codebuild/${local.name_codebuild_project}"
  retention_in_days = 7
}
