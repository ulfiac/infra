variable "expire_alb_logs_in_days" {
  description = "Number of days after which ALB logs expire."
  type        = number
  default     = 30
}

variable "expire_athena_results_in_days" {
  description = "Number of days after which Athena query results expire."
  type        = number
  default     = 10
}

variable "expire_cloudtrail_logs_in_days" {
  description = "Number of days after which CloudTrail logs expire."
  type        = number
  default     = 30
}

variable "expire_nlb_logs_in_days" {
  description = "Number of days after which NLB logs expire."
  type        = number
  default     = 30
}

variable "expire_noncurrent_object_versions_in_days" {
  description = "Number of days after which noncurrent object versions expire."
  type        = number
  default     = 10
}

variable "expire_route53_logs_in_days" {
  description = "Number of days after which Route53 logs expire."
  type        = number
  default     = 30
}

variable "expire_vpc_flow_logs_in_days" {
  description = "Number of days after which VPC Flow logs expire."
  type        = number
  default     = 3
}

variable "log_group_retention_in_days" {
  description = "The number of days to retain log events in the specified log group."
  type        = number
  default     = 30
}
