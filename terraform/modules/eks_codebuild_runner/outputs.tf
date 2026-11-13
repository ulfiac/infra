output "security_group_id" {
  description = "The ID of the security group for the CodeBuild runner"
  value       = aws_security_group.codebuild_runner.id
}

