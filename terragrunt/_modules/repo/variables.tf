variable "name" {
  description = "The name of the repository"
  type        = string
}

variable "description" {
  description = "A description for the repository"
  type        = string
  default     = ""
}

variable "visibility" {
  description = "Visibility of the repository (public/private)"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "Visibility must be either 'public' or 'private'."
  }
}
