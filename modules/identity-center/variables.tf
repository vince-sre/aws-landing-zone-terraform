variable "permission_sets" {
  description = "Permission sets: managed policies plus session duration. No IAM users anywhere."
  type = map(object({
    description      = string
    managed_policies = list(string)
    session_duration = string
  }))
  default = {
    PlatformAdmin = {
      description      = "Platform team admin (time-boxed sessions)"
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      session_duration = "PT2H"
    }
    Developer = {
      description      = "Workload developers: power user without IAM"
      managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      session_duration = "PT8H"
    }
    ReadOnly = {
      description      = "Auditors and on-call read access"
      managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      session_duration = "PT8H"
    }
    SecurityAudit = {
      description      = "Security team audit access"
      managed_policies = ["arn:aws:iam::aws:policy/SecurityAudit", "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
      session_duration = "PT4H"
    }
  }
}
