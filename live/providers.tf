# Default provider = management account (credentials from SSO).
provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "log_archive"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${var.log_archive_account_id}:role/${var.cross_account_role}"
    session_name = "landing-zone"
  }
}

provider "aws" {
  alias  = "security"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${var.security_account_id}:role/${var.cross_account_role}"
    session_name = "landing-zone"
  }
}
