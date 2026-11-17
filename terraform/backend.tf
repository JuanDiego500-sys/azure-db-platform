terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatem9espg"
    container_name       = "tfstate"
    key                  = "azure-db-platform.tfstate"
    use_azuread_auth     = true
  }
}