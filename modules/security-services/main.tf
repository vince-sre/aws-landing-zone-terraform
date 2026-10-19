# Runs in the delegated-admin (Security/Audit) account. Delegation itself is
# done from the management account in live/main.tf.
data "aws_region" "current" {}
data "aws_partition" "current" {}

resource "aws_guardduty_detector" "this" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

resource "aws_guardduty_organization_configuration" "this" {
  detector_id                      = aws_guardduty_detector.this.id
  auto_enable_organization_members = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "eks_audit" {
  detector_id = aws_guardduty_detector.this.id
  name        = "EKS_AUDIT_LOGS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "runtime" {
  detector_id = aws_guardduty_detector.this.id
  name        = "RUNTIME_MONITORING"
  auto_enable = "ALL"
}

resource "aws_securityhub_account" "this" {
  enable_default_standards = false
  auto_enable_controls     = true
}

resource "aws_securityhub_organization_configuration" "this" {
  auto_enable           = true
  auto_enable_standards = "NONE"

  depends_on = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each = toset(var.security_standards)

  standards_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.name}::${each.value}"

  depends_on = [aws_securityhub_account.this]
}

# Aggregate findings from every region into this one.
resource "aws_securityhub_finding_aggregator" "this" {
  linking_mode = "ALL_REGIONS"

  depends_on = [aws_securityhub_account.this]
}

resource "aws_accessanalyzer_analyzer" "org" {
  analyzer_name = "org-external-access"
  type          = "ORGANIZATION"
}
