resource "aws_cloudwatch_log_group" "codebuild_runner" {
  name              = "/aws/codebuild/${local.name_codebuild_runner_linux_arm64}"
  retention_in_days = 7
}
