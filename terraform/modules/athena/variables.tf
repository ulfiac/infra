variable "bucket_name" {
  description = "The name of the S3 bucket where logs and Athena query results are stored."
  type        = string
}

variable "key_prefixes" {
  description = "A map of S3 key prefixes for storing different types of logs and Athena query results."
  type        = map(string)
}
