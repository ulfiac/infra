variable "github_connection_arn" {
  description = "The ARN of the AWS CodeConnections (or CodeStar Connections) GitHub connection."
  type        = string

  validation {
    condition     = can(regex("^arn:aws(-us-gov|-cn)?:code(star-)?connections:[a-z0-9-]+:[0-9]{12}:connection/[a-zA-Z0-9-]+$", var.github_connection_arn))
    error_message = "The github_connection_arn must be a valid AWS CodeConnections or CodeStar Connections ARN (e.g., arn:aws:codeconnections:us-east-1:123456789012:connection/abc-123)."
  }
}
