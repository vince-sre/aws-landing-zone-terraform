variable "region" {
  description = "Home region for the landing zone."
  type        = string
  default     = "us-east-1"
}

variable "log_archive_account_id" {
  description = "Account ID of the Log Archive account (supplied at plan time, never committed)."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.log_archive_account_id))
    error_message = "Must be a 12-digit account ID."
  }
}

variable "security_account_id" {
  description = "Account ID of the Security/Audit account (delegated admin)."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.security_account_id))
    error_message = "Must be a 12-digit account ID."
  }
}

variable "cross_account_role" {
  description = "Role assumed in member accounts."
  type        = string
  default     = "OrganizationAccountAccessRole"
}
