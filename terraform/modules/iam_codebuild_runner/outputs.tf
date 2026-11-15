output "codebuild_runner_iam_role_arn" {
  description = "The ARN of the IAM role for the CodeBuild runner"
  value       = aws_iam_role.codebuild_runner.arn
}
