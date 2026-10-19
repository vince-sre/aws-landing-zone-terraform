output "ou_ids" {
  description = "OU name to ID."
  value       = module.organization.ou_ids
}

output "log_bucket" {
  description = "Central log archive bucket."
  value       = module.log_archive.bucket_name
}

output "permission_sets" {
  description = "Identity Center permission sets."
  value       = module.identity_center.permission_set_arns
}
