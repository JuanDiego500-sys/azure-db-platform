# terraform

Infrastructure as code for Azure.

Will contain (Phase 2–4):
- Resource group, virtual network, subnet, and network security group
- Linux VM (`Standard_B2s`) that runs k3s
- Azure Key Vault for secrets
- Remote state backend in Azure Storage

Variable values go in `*.tfvars` files, which are **git-ignored**.
Use `terraform.tfvars.example` as a template.