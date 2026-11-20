package terraform.policies.labels

import future.keywords.in

required_labels := ["environment", "owner", "cost_center", "managed_by"]

label_checked_types := {
	"google_storage_bucket",
	"google_compute_instance",
}

deny contains msg if {
	some rc in input.resource_changes
	rc.type in label_checked_types
	"create" in rc.change.actions
	labels := object.get(rc.change.after, "labels", {})
	some req_label in required_labels
	not labels[req_label]
	msg := sprintf("Policy Violation [mandatory_labels]: Resource '%s' (%s) is missing required label '%s'.", [rc.address, rc.type, req_label])
}
