variable "organizational_units" {
  description = "Top-level OUs to create under the root."
  type        = list(string)
  default     = ["Security", "Infrastructure", "Workloads-NonProd", "Workloads-Prod", "Sandbox", "Suspended"]
}

variable "allowed_regions" {
  description = "Regions workloads may use. Global services are exempt in the SCP."
  type        = list(string)
  default     = ["us-east-1", "us-east-2", "us-west-2"]
}

variable "break_glass_role_name" {
  description = "Role name exempt from guardrail SCPs (break-glass / automation)."
  type        = string
  default     = "OrganizationAccountAccessRole"
}
