variable "security_standards" {
  description = "Security Hub standards to enable org-wide (ARN suffixes)."
  type        = list(string)
  default = [
    "standards/aws-foundational-security-best-practices/v/1.0.0",
    "standards/cis-aws-foundations-benchmark/v/1.4.0",
  ]
}
