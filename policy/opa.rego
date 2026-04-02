package terraform.policy_only_v0

import input.plan as tfplan
import input.run as tfrun

allowed_resources = [
  "aws_security_group",
  "aws_s3_bucket"
]
allowed_actions = ["create", "update"]

# METADATA
# title: only-v0-policy
# custom:
#  enforcement_level: mandatory
deny[outcome] {
  rc := tfplan.resource_changes[_]
  action := rc.change.actions[count(rc.change.actions) - 1]
  allowed_actions[_] == action

  not is_allowed(rc.type)

  outcome := {
    "policy_name": rego.metadata.rule().title,
    "enforcement_level": rego.metadata.rule().custom.enforcement_level,
    "output": sprintf("%s: resource type %q is not allowed for workspace %s", [rc.address, rc.type, tfrun.workspace])
  }
}

is_allowed(t) {
  allowed_resources[i] == t
}
