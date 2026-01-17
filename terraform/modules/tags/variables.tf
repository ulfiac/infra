variable "additional_tags" {
  description = "Additional tags to merge with standard tags"
  type        = map(string)
  default     = {}
}

variable "created_by" {
  description = "Name of the entity or user that created the resource"
  type        = string
  default     = "terraform"
}

variable "repo" {
  description = "Name of the repository that created the resource"
  type        = string
  default     = ""
}
