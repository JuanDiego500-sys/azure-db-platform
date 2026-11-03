output "resource_group_name" {
  description = "Name of the resource group that contains all project resources."
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Full Azure resource ID of the resource group."
  value       = azurerm_resource_group.main.id
}

output "vm_public_ip" {
  description = "Public IP address of the VM."
  value       = azurerm_public_ip.vm.ip_address
}

output "ssh_command" {
  description = "Command to connect to the VM."
  value       = "ssh -i ~/.ssh/id_ed25519_azure ${var.admin_username}@${azurerm_public_ip.vm.ip_address}"
}

output "key_vault_name" {
  description = "Name of the Key Vault (includes a random suffix)."
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI used by apps and External Secrets Operator to reach the vault."
  value       = azurerm_key_vault.main.vault_uri
}