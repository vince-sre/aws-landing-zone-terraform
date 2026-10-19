variable "bucket_prefix" {
  description = "Prefix for the central log bucket; the account ID is appended."
  type        = string
  default     = "org-log-archive"
}

variable "organization_id" {
  description = "AWS Organizations ID (o-xxxxxxxxxx), used to scope the bucket policy."
  type        = string
}

variable "retention_days" {
  description = "Days before logs expire. Glacier transition happens at 90 days."
  type        = number
  default     = 2555
}
