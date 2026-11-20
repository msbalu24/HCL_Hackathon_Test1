# Enterprise Multi-Environment GCP Infrastructure with Terraform, HCP Terraform, Vault, OPA, Checkov & GitHub Actions

## Architecture Overview

    +-------------------------------------------------------------------+
    |                        GitHub Repository                          |
    |                  (msbalu24/HCL_Hackathon_Test1)                   |
    |  - Reusable Modules: networking, iam, storage, compute            |
    |  - Environments: environments/dev, environments/prod              |
    |  - Policy as Code (OPA): policies/mandatory_labels.rego,          |
    |    policies/security_checks.rego                                  |
    |  - Static Security (Checkov): .checkov.yaml                       |
    |  - CI/CD Pipeline: .github/workflows/terraform-cicd.yml           |
    +---------------------------------+---------------------------------+
                                      |
             +------------------------+------------------------+
             |                                                 |
             v (CI/CD: fmt, validate, Checkov, OPA)            v (Remote Execution & State)
    +-----------------+                           +-----------------------------------+
    | GitHub Actions  |                           |        HCP Terraform Cloud        |
    |    Runner       |                           |  Org: balu-hcl-tf-org             |
    | (TF_API_TOKEN)  |                           |  Workspaces:                      |
    +-----------------+                           |   - gcp-infra-dev (dir: env/dev)  |
                                                  |   - gcp-infra-prod (dir: env/prod)|
                                                  |  Env Var Set: GOOGLE_CREDENTIALS  |
                                                  +-----------------+-----------------+
                                                                    |
                                        +---------------------------+---------------------------+
                                        |                                                       |
                                        v                                                       v
                            +-----------------------+                               +-----------------------+
                            |   Google Cloud (GCP)  |                               |    HashiCorp Vault    |
                            | Project:              |                               | Dynamic KV-v2 Secrets |
                            | hcl-hackathon-tf-gcp- |                               | vault_kv_secret_v2    |
                            | demo2                 |                               | (zero hardcoded       |
                            | - Custom VPC & Subnet |                               |  secrets in code)     |
                            | - IAP & Internal FW   |                               +-----------------------+
                            | - Least-Priv IAM SA   |
                            | - Versioned GCS Bucket|
                            | - Shielded Private VM |
                            +-----------------------+

## Complete Project File & Folder Tree

    HCL_Hackathon_Test1/
    |-- .checkov.yaml
    |-- .gitattributes
    |-- README.md
    |-- .github/
    |   `-- workflows/
    |       `-- terraform-cicd.yml
    |-- environments/
    |   |-- dev/
    |   |   |-- main.tf
    |   |   |-- outputs.tf
    |   |   |-- terraform.tfvars
    |   |   |-- vault.tf
    |   |   |-- variables.tf
    |   |   `-- versions.tf
    |   `-- prod/
    |       |-- .terraform.lock.hcl
    |       |-- main.tf
    |       |-- outputs.tf
    |       |-- terraform.tfvars
    |       |-- variables.tf
    |       `-- versions.tf
    |-- modules/
    |   |-- compute/
    |   |   |-- main.tf
    |   |   |-- outputs.tf
    |   |   `-- variables.tf
    |   |-- iam/
    |   |   |-- main.tf
    |   |   |-- outputs.tf
    |   |   `-- variables.tf
    |   |-- networking/
    |   |   |-- main.tf
    |   |   |-- outputs.tf
    |   |   `-- variables.tf
    |   `-- storage/
    |       |-- main.tf
    |       |-- outputs.tf
    |       `-- variables.tf
    |-- policies/
    |   |-- mandatory_labels.rego
    |   `-- security_checks.rego
    `-- scripts/
        `-- setup_vault_demo.sh

## Key Capabilities & Phases Implemented

1. **Foundation & Remote State (`HCP Terraform` + `GCP`):** Configured HCP Terraform organization `balu-hcl-tf-org` with `gcp-infra-dev` and `gcp-infra-prod` workspaces, sensitive `GOOGLE_CREDENTIALS`, and GCP project `hcl-hackathon-tf-gcp-demo2` with service account `terraform-hcp-sa`.
2. **Modular Reusable Infrastructure (`DRY`):** Built four modular components (`networking`, `iam`, `storage`, `compute`) consumed across isolated `dev` and `prod` environments.
3. **HashiCorp Vault Integration:** Integrated `hashicorp/vault` provider and `data "vault_kv_secret_v2"` in `environments/dev/vault.tf` with an `enable_vault` feature flag so zero secrets are hardcoded.
4. **Policy as Code (`OPA`) & Static Security (`Checkov`):** Added OPA Rego v1 policies (`policies/mandatory_labels.rego` and `policies/security_checks.rego`) and Checkov scanning (`.checkov.yaml`).
5. **Automated CI/CD (`GitHub Actions`):** Configured `.github/workflows/terraform-cicd.yml` using `TF_API_TOKEN` to execute `terraform fmt -check`, `terraform init`/`validate`, `checkov`, and `opa check`.
6. **SRE Operations — State Drift & Failure Troubleshooting:** Verified out-of-band console drift detection and reconciliation via `terraform plan`/`apply`, plus invalid zone troubleshooting and recovery.

## How to Explain & Show Dashboards to Reviewers

- **HCP Terraform UI (`app.terraform.io`):** Show `balu-hcl-tf-org` workspaces (`gcp-infra-dev`, `gcp-infra-prod`), **Runs** history/logs, remote state, and **Variable sets** (`GOOGLE_CREDENTIALS`).
- **GCP Console:** Show provisioned resources in `hcl-hackathon-tf-gcp-demo2` (VPC, Subnet, Firewall rules, Service Accounts, GCS bucket, and private GCE instance).
- **GitHub Actions & Code:** Show `.github/workflows/terraform-cicd.yml`, `policies/*.rego`, `.checkov.yaml`, and green (`✓`) workflow runs.
