variable "group_name" {
  description = "The name of the group the mobile user is made a member of."
  type        = string
  default     = "mobile-notifications-group"
}

variable "pgp_key" {
  description = "The base64 encoded binary PGP public key used to encrypt the mobile user's initial password."
  type        = string
}

variable "policy_name_app_access" {
  description = "The name of the customer-managed policy that grants access to push notifications, CloudWatch alarms, and costs in the AWS Console Mobile App."
  type        = string
  default     = "mobile-notifications-app-access"
}

variable "policy_name_guardrails" {
  description = "The name of the customer-managed policy that explicitly denies privilege escalation and tampering with alarms and notifications."
  type        = string
  default     = "mobile-notifications-guardrails"
}

variable "policy_name_self_manage" {
  description = "The name of the inline group policy that allows the mobile user to manage their own password and MFA device and enforces MFA."
  type        = string
  default     = "mobile-notifications-self-manage"
}

variable "user_name" {
  description = "The name of the mobile user to be created."
  type        = string
  default     = "mobile-notifications"
}

variable "user_password_length" {
  description = "The length of the mobile user's password."
  type        = number
  default     = 42
}

variable "user_password_reset_required" {
  description = "Whether the mobile user is required to reset their password on first login."
  type        = bool
  default     = true
}
