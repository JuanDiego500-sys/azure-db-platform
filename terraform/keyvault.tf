# Reads who is running Terraform (tenant + my user's object ID).
data "azurerm_client_config" "current" {}

# Key Vault names are global across all of Azure, so add a random suffix.
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "main" {
  name                = "kv-dbplat-${random_string.kv_suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = var.tags

  # Use Azure RBAC roles instead of legacy access policies.
  rbac_authorization_enabled = true

  # Learning project: keep it easy to destroy and recreate.
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
}

# Give me (whoever runs Terraform) permission to manage secrets in the vault.
resource "azurerm_role_assignment" "kv_secrets_officer_me" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}