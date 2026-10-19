variable "name" {
  description = "Trail name."
  type        = string
  default     = "org-trail"
}

variable "s3_bucket_name" {
  description = "Log archive bucket (in the log-archive account)."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key used to encrypt trail logs."
  type        = string
}
