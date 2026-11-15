output "github_connection_arn" {
  description = "The ARN of the GitHub connection"
  value       = aws_codeconnections_connection.github.arn
}

output "github_connection_status" {
  description = "The status of the GitHub connection"
  value       = aws_codeconnections_connection.github.connection_status
}
