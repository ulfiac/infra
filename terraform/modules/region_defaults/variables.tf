variable "log_bucket_name" {
  description = "Name of the S3 bucket to store logs"
  type        = string
}

variable "log_bucket_arn" {
  description = "ARN of the S3 bucket to store logs"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Enable mapping of public IP on launch for default subnets"
  type        = bool
  default     = false
}

variable "verbose_output" {
  description = "Enable verbose output for debugging purposes"
  type        = bool
  default     = false
}
