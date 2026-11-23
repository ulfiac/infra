variable "github_connection_arn" {
  description = "The ARN of the GitHub code connection used by the CodeBuild runner"
  type        = string

  validation {
    condition     = can(regex("^arn:aws(-us-gov|-cn)?:code(star-)?connections:[a-z0-9-]+:[0-9]{12}:connection/[a-zA-Z0-9-]+$", var.github_connection_arn))
    error_message = "The github_connection_arn must be a valid AWS CodeConnections or CodeStar Connections ARN (e.g., arn:aws:codeconnections:us-east-1:123456789012:connection/abc-123)."
  }
}

variable "image" {
  default     = "ghcr.io/ulfiac/terra-runner:1.2.2@sha256:da3bec9a841f7153801933024133c1df8504ddbace240a57fe1577bbe8ee5ea0"
  description = "The Docker image used by the CodeBuild runner"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets in the VPC"
  type        = set(string)

  validation {
    condition     = length(var.private_subnet_ids) > 0 && length(var.private_subnet_ids) <= 16
    error_message = "private_subnet_ids must contain between 1 and 16 subnet IDs (CodeBuild limit)."
  }

  validation {
    condition     = alltrue([for id in var.private_subnet_ids : can(regex("^subnet-([0-9a-f]{8}|[0-9a-f]{17})$", id))])
    error_message = "Each private_subnet_ids entry must be a valid subnet ID (e.g., subnet-0123456789abcdef0)."
  }
}

variable "verify_github_connection" {
  description = "Look up the GitHub connection and require it to be AVAILABLE. Disable only for mock-backed plans where the connection does not exist yet."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string

  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID (e.g., vpc-0123456789abcdef0)."
  }
}
