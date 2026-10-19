"""Render every SCP template and check it is valid JSON under the AWS size limit.

AWS rejects SCPs over 5,120 characters (whitespace counts), so this catches a
policy that has grown too large before `terraform apply` does.
"""

import json
import pathlib
import re

import pytest

POLICY_DIR = pathlib.Path(__file__).resolve().parents[1] / "modules" / "organization" / "policies"
SCP_MAX_CHARS = 5120
VARS = {
    "allowed_regions": json.dumps(["us-east-1", "us-east-2", "us-west-2"]),
    "exempt_role_arn": "arn:aws:iam::*:role/OrganizationAccountAccessRole",
}
TEMPLATES = sorted(POLICY_DIR.glob("*.json.tftpl"))


def render(text: str) -> str:
    return re.sub(r"\$\{(\w+)\}", lambda m: VARS[m.group(1)], text)


def test_templates_found():
    assert TEMPLATES, f"no templates in {POLICY_DIR}"


@pytest.mark.parametrize("path", TEMPLATES, ids=lambda p: p.name)
def test_scp_is_valid_json(path):
    doc = json.loads(render(path.read_text()))
    assert doc["Version"] == "2012-10-17"
    assert doc["Statement"], "policy has no statements"


@pytest.mark.parametrize("path", TEMPLATES, ids=lambda p: p.name)
def test_scp_under_size_limit(path):
    minified = json.dumps(json.loads(render(path.read_text())), separators=(",", ":"))
    assert len(minified) <= SCP_MAX_CHARS


@pytest.mark.parametrize("path", TEMPLATES, ids=lambda p: p.name)
def test_scp_statements_are_deny_with_sid(path):
    for stmt in json.loads(render(path.read_text()))["Statement"]:
        assert stmt["Effect"] == "Deny", "guardrail SCPs should only deny"
        assert stmt.get("Sid"), "every statement needs a Sid for readable audit trails"


def test_every_attached_policy_has_a_template():
    main_tf = (POLICY_DIR.parent / "main.tf").read_text()
    block = main_tf.split("scp_attachments = {", 1)[1].split("}", 1)[0]
    names = re.findall(r'"([a-z0-9-]+)"\s*=', block)
    assert names
    for name in names:
        assert (POLICY_DIR / f"{name}.json.tftpl").exists(), name
