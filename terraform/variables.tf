variable "project_name" {
  description = "Short name used as a prefix for all resource names."
  type        = string
  default     = "azure-db-platform"
}

variable "location" {
  description = "Azure region where resources will be created."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    project    = "azure-db-platform"
    managed_by = "terraform"
  }
}

variable "allowed_ssh_cidr" {
  description = "Your public IP in CIDR notation (e.g. 203.0.113.10/32). Only this address can SSH to the VM."
  type        = string
}
# B2s was unavailable for this Free Trial subscription in eastus
# (SkuNotAvailable / NotAvailableForSubscription), so we use D2als_v7.
variable "vm_size" {
  description = "Azure VM size. D2als_v7 = 2 vCPU (AMD) / 4 GB RAM, ~USD 0.08/hour."
  type        = string
  default     = "Standard_D2als_v7"
}

variable "admin_username" {
  description = "Linux admin user for SSH."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key that is allowed to log in to the VM."
  type        = string
  default     = "~/.ssh/id_ed25519_azure.pub"
}