data "aws_organizations_organization" "this" {}

locals {
  root_id = data.aws_organizations_organization.this.roots[0].id

  # Which SCPs attach to which OU. "root" attaches org-wide.
  scp_attachments = {
    "deny-leave-org"           = ["root"]
    "deny-root-user"           = ["root"]
    "protect-security-tooling" = ["root"]
    "region-restriction"       = ["Workloads-NonProd", "Workloads-Prod", "Sandbox", "Infrastructure"]
    "require-imdsv2"           = ["Workloads-NonProd", "Workloads-Prod", "Sandbox"]
    "deny-all"                 = ["Suspended"]
  }

  attachments = merge([
    for policy, targets in local.scp_attachments : {
      for t in targets : "${policy}:${t}" => {
        policy = policy
        target = t == "root" ? local.root_id : aws_organizations_organizational_unit.this[t].id
      }
    }
  ]...)
}

resource "aws_organizations_organizational_unit" "this" {
  for_each = toset(var.organizational_units)

  name      = each.value
  parent_id = local.root_id
}

resource "aws_organizations_policy" "scp" {
  for_each = local.scp_attachments

  name        = each.key
  description = "Guardrail: ${each.key}"
  type        = "SERVICE_CONTROL_POLICY"
  content = templatefile("${path.module}/policies/${each.key}.json.tftpl", {
    allowed_regions = jsonencode(var.allowed_regions)
    exempt_role_arn = "arn:aws:iam::*:role/${var.break_glass_role_name}"
  })
}

resource "aws_organizations_policy_attachment" "scp" {
  for_each = local.attachments

  policy_id = aws_organizations_policy.scp[each.value.policy].id
  target_id = each.value.target
}
