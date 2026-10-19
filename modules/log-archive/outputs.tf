output "bucket_name" {
  description = "Central log bucket."
  value       = aws_s3_bucket.logs.id
}

output "kms_key_arn" {
  description = "KMS key for log encryption."
  value       = aws_kms_key.logs.arn
}
