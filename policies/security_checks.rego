package terraform.policies.security

import rego.v1

# 1. Block open 0.0.0.0/0 ingress source ranges on firewall rules
deny contains msg if {
	some rc in input.resource_changes
	rc.type == "google_compute_firewall"
	"create" in rc.change.actions
	some cidr in object.get(rc.change.after, "source_ranges", [])
	cidr == "0.0.0.0/0"
	msg := sprintf("Policy Violation [security_checks]: Firewall rule '%s' must not allow 0.0.0.0/0 ingress.", [rc.address])
}

# 2. Enforce public access prevention on GCS buckets
deny contains msg if {
	some rc in input.resource_changes
	rc.type == "google_storage_bucket"
	"create" in rc.change.actions
	pap := object.get(rc.change.after, "public_access_prevention", "")
	pap != "enforced"
	msg := sprintf("Policy Violation [security_checks]: GCS bucket '%s' must enforce public_access_prevention.", [rc.address])
}

# 3. Disallow public IP access_config blocks on compute instances
deny contains msg if {
	some rc in input.resource_changes
	rc.type == "google_compute_instance"
	"create" in rc.change.actions
	some nic in object.get(rc.change.after, "network_interface", [])
	count(object.get(nic, "access_config", [])) > 0
	msg := sprintf("Policy Violation [security_checks]: Compute instance '%s' must not have a public IP access_config.", [rc.address])
}
