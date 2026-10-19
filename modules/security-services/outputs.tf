output "guardduty_detector_id" {
  description = "GuardDuty detector in the delegated-admin account."
  value       = aws_guardduty_detector.this.id
}
