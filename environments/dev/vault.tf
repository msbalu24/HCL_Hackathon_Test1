variable "vault_address" {
  description = "HashiCorp Vault server URL (can be overridden via TF_VAR_vault_address)"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "enable_vault" {
  description = "Toggle to enable dynamic secret retrieval from HashiCorp Vault"
  type        = bool
  default     = false
}

variable "vault_secret_mount" {
  description = "KV-v2 mount path in HashiCorp Vault"
  type        = string
  default     = "secret"
}

variable "vault_secret_name" {
  description = "Secret path inside HashiCorp Vault"
  type        = string
  default     = "hcl-hackathon/dev/app-config"
}

# Dynamically fetch application secrets from HashiCorp Vault at runtime (zero hardcoded secrets)
data "vault_kv_secret_v2" "app_secrets" {
  count = var.enable_vault ? 1 : 0

  mount = var.vault_secret_mount
  name  = var.vault_secret_name
}

locals {
  resolved_app_api_key = var.enable_vault ? nonsensitive(data.vault_kv_secret_v2.app_secrets[0].data["api_key"]) : "vault-placeholder-dev-mode"
}

output "vault_integration_status" {
  description = "Shows whether secrets were dynamically sourced from HashiCorp Vault"
  value       = var.enable_vault ? "ENABLED - Dynamic secret loaded from Vault (${var.vault_secret_mount}/${var.vault_secret_name})" : "STANDBY - Vault provider configured (set enable_vault=true with VAULT_ADDR & VAULT_TOKEN)"
}
