# bootstrap-backend.ps1
#
# Creates the Azure Storage backend for the Terraform state. Run it ONCE,
# before the first `terraform init`.
#
# Why a script and not Terraform? Chicken-and-egg: Terraform needs this storage
# account to exist before it can store its state there, so the storage account
# cannot be managed by the same Terraform project.
#
# Usage (from the repo root, logged in with `az login`):
#   ./scripts/bootstrap-backend.ps1                          # random account name
#   ./scripts/bootstrap-backend.ps1 -StorageAccount sttfstatexxxxxx  # reuse a name
#
# Safe to re-run: every command is idempotent (it creates or leaves as is).

param(
    [string]$ResourceGroup  = "rg-tfstate",
    [string]$Location       = "eastus",
    [string]$StorageAccount = "",
    [string]$Container      = "tfstate"
)

$ErrorActionPreference = "Stop"

# Storage account names are global, 3-24 chars, lowercase letters and digits only.
if (-not $StorageAccount) {
    $suffix = -join ((97..122) + (48..57) | Get-Random -Count 6 | ForEach-Object { [char]$_ })
    $StorageAccount = "sttfstate$suffix"
}

Write-Host "==> Resource group $ResourceGroup"
az group create -n $ResourceGroup -l $Location --output none

Write-Host "==> Storage account $StorageAccount (TLS 1.2, no public blobs, no access keys)"
az storage account create -n $StorageAccount -g $ResourceGroup -l $Location `
    --sku Standard_LRS --kind StorageV2 `
    --min-tls-version TLS1_2 `
    --allow-blob-public-access false `
    --allow-shared-key-access false `
    --output none

Write-Host "==> Blob versioning + 7-day soft delete (lets us restore an old state)"
az storage account blob-service-properties update --account-name $StorageAccount -g $ResourceGroup `
    --enable-versioning true `
    --enable-delete-retention true --delete-retention-days 7 `
    --output none

Write-Host "==> Role 'Storage Blob Data Contributor' for the signed-in user"
$me    = az ad signed-in-user show --query id -o tsv
$scope = az storage account show -n $StorageAccount -g $ResourceGroup --query id -o tsv
$existing = az role assignment list --assignee $me --role "Storage Blob Data Contributor" --scope $scope --query "[0].id" -o tsv
if (-not $existing) {
    az role assignment create --assignee $me --role "Storage Blob Data Contributor" --scope $scope --output none
    Write-Host "    Waiting 60s for the role assignment to propagate..."
    Start-Sleep -Seconds 60
}

Write-Host "==> Container $Container"
az storage container create -n $Container --account-name $StorageAccount --auth-mode login --output none

Write-Host ""
Write-Host "Done. Use these values in the backend block (terraform/backend.tf):"
Write-Host "  resource_group_name  = `"$ResourceGroup`""
Write-Host "  storage_account_name = `"$StorageAccount`""
Write-Host "  container_name       = `"$Container`""
