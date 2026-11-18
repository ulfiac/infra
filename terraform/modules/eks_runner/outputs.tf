output "security_group_id" {
  description = "The ID of the security group for the CodeBuild runner"
  value       = aws_security_group.eks_runner.id
}

output "service_role_arn" {
  description = "The ARN of the service role for the CodeBuild runner"
  value       = aws_iam_role.eks_runner_service_role.arn
}
