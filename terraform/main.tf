resource "azurerm_resource_group" "main" {
  name     = "rg-azure-db-platform"
  location = "eastus"

  tags = {
    project    = "azure-db-platform"
    managed_by = "terraform"
  }
}