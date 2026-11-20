#!/usr/bin/env bash
set -euo pipefail

echo "=== HashiCorp Vault Local/CI Demo Setup ==="
# Start Vault in dev mode (or connect to HCP Vault Dedicated)
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="hcl-demo-root-token"

# Seed application secrets into Vault KV-v2 engine
vault kv put secret/hcl-hackathon/dev/app-config \
  api_key="prod-grade-dynamic-secret-9988" \
  db_user="hcl_sre_app"

echo "Secret seeded at secret/hcl-hackathon/dev/app-config"
echo "Run Terraform with: TF_VAR_enable_vault=true terraform -chdir=environments/dev plan"
