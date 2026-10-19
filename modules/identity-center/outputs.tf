output "permission_set_arns" {
  description = "Permission set name to ARN."
  value       = { for k, v in aws_ssoadmin_permission_set.this : k => v.arn }
}
