variable "prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "default"
}

variable "enable_default_ebs_encryption" {
  description = "Enable default EBS encryption for the region"
  type        = bool
  default     = true
}

variable "verbose_output" {
  description = "Enable verbose output for debugging purposes"
  type        = bool
  default     = false
}
