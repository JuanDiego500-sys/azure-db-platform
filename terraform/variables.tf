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