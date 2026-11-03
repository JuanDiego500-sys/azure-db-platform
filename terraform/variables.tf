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