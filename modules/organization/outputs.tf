output "ou_ids" {
  description = "Map of OU name to OU ID."
  value       = { for k, v in aws_organizations_organizational_unit.this : k => v.id }
}

output "scp_ids" {
  description = "Map of SCP name to policy ID."
  value       = { for k, v in aws_organizations_policy.scp : k => v.id }
}
