variable "monthly_budget_usd" {
  description = "Monthly cost budget for the account; alerts at 80% actual and 100% forecast."
  type        = number
  default     = 1000
}

variable "budget_alert_emails" {
  description = "Addresses that receive budget alerts."
  type        = list(string)
  default     = []
}
