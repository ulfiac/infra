variable "default_group_name" {
  description = "The name of the default group."
  type        = string
  default     = "default-group"
}

variable "default_group_policy_name_enforce_mfa" {
  description = "The name of the default group policy to enforce MFA."
  type        = string
  default     = "enforce-mfa"
}

variable "default_group_policy_name_roleswitch" {
  description = "The name of the default group policy for role switching."
  type        = string
  default     = "role-switch"
}

variable "role_max_session_duration" {
  description = "The roles' maximum session duration in seconds."
  type        = number
  default     = 43200 # 12 hours
}

variable "role_name_roleswitch_admin" {
  description = "The name of the role for admin role switching."
  type        = string
  default     = "role-switch-admin"
}

variable "role_name_roleswitch_poweruser" {
  description = "The name of the role for power user role switching."
  type        = string
  default     = "role-switch-poweruser"
}

variable "user_name" {
  description = "The name of the user to be created."
  type        = string
  default     = "actual"
}

variable "user_password_length" {
  description = "The length of the user's password."
  type        = number
  default     = 42
}

variable "user_password_reset_required" {
  description = "Whether the user is required to reset their password on first login."
  type        = bool
  default     = true
}
