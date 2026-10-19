data "aws_organizations_organization" "this" {}

module "organization" {
  source = "../modules/organization"
}

module "log_archive" {
  source    = "../modules/log-archive"
  providers = { aws = aws.log_archive }

  organization_id = data.aws_organizations_organization.this.id
}

module "org_trail" {
  source = "../modules/org-trail"

  s3_bucket_name = module.log_archive.bucket_name
  kms_key_arn    = module.log_archive.kms_key_arn
}

# Delegate security services to the Security account from the management account.
resource "aws_guardduty_organization_admin_account" "this" {
  admin_account_id = var.security_account_id
}

resource "aws_securityhub_organization_admin_account" "this" {
  admin_account_id = var.security_account_id
}

resource "aws_organizations_delegated_administrator" "access_analyzer" {
  account_id        = var.security_account_id
  service_principal = "access-analyzer.amazonaws.com"
}

module "security_services" {
  source    = "../modules/security-services"
  providers = { aws = aws.security }

  depends_on = [
    aws_guardduty_organization_admin_account.this,
    aws_securityhub_organization_admin_account.this,
    aws_organizations_delegated_administrator.access_analyzer,
  ]
}

module "identity_center" {
  source = "../modules/identity-center"
}

module "baseline_management" {
  source = "../modules/account-baseline"
}
