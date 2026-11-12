output "github_codeconnection_arn" {
  description = "The ARN of the GitHub code connection"
  value       = aws_codeconnections_connection.github.arn
}

output "github_codeconnection_status" {
  description = "The status of the GitHub code connection"
  value       = aws_codeconnections_connection.github.connection_status
}
