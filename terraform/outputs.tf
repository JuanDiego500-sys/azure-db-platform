output "resource_group_name" {
  description = "Name of the resource group that contains all project resources."
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Full Azure resource ID of the resource group."
  value       = azurerm_resource_group.main.id
}