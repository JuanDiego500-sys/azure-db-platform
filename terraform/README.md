# terraform

Infrastructure as code for Azure.

## What it creates

- Resource group, virtual network, subnet, and network security group (SSH only from my IP)
- Linux VM (`Standard_D2als_v7`) that will run k3s, with a daily auto-shutdown
- Azure Key Vault (RBAC mode) for secrets

## State

The Terraform state is **not** stored in this repo. It lives in Azure Storage
(see `backend.tf`):

| Setting | Value |
|---|---|
| Resource group | `rg-tfstate` (separate, never destroyed by this project) |
| Storage account | `sttfstatem9espg` (no access keys, Azure AD auth only) |
| Container / blob | `tfstate` / `azure-db-platform.tfstate` |

The backend is created once with [`../scripts/bootstrap-backend.ps1`](../scripts/bootstrap-backend.ps1).
Blob versioning and soft delete are enabled, so an older state can be restored.
Your identity needs the **Storage Blob Data Contributor** role on the storage account.

## Usage

```powershell
$env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)
terraform init
terraform plan
terraform apply
```

Variable values go in `*.tfvars` files, which are **git-ignored**.
Use `terraform.tfvars.example` as a template.
