# azure-db-platform

A GitOps platform on Azure: **Terraform** builds the infrastructure, **GitHub Actions** runs it,
and **Argo CD** deploys **PostgreSQL** (with **pgvector**) into a lightweight Kubernetes cluster.
This repository is the single source of truth.

> 🚧 **Work in progress.**
> See the [roadmap](#roadmap) for current status.

## Architecture

```
GitHub (source of truth)
 ├── terraform/  ──► GitHub Actions ──► Azure: VM + Key Vault + network
 └── k8s/        ──► Argo CD (on the VM) ──► PostgreSQL (app_db + vector_db)
                                              ▲
                     Azure Key Vault ──► External Secrets Operator
```

## Tech stack

| Area | Tool |
|---|---|
| Cloud | Microsoft Azure (VM, Key Vault, Storage) |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions (OIDC to Azure, no stored secrets) |
| Kubernetes | k3s (single node, inside the VM) |
| GitOps | Argo CD |
| Database | PostgreSQL + pgvector |
| Secrets | Azure Key Vault + External Secrets Operator |
| Debugging | k9s |

## Repository structure

| Folder | Contents |
|---|---|
| [`terraform/`](terraform/) | Azure infrastructure as code |
| [`k8s/`](k8s/) | Kubernetes manifests that Argo CD deploys |
| [`.github/workflows/`](.github/workflows/) | CI/CD pipelines |
| [`docs/`](docs/) | Guides, diagrams, and screenshots |
| [`scripts/`](scripts/) | Helper scripts |

## Roadmap

- [x] 1. Foundations: repo structure, license, tooling
- [ ] 2. Local Terraform: network, VM, Key Vault
- [ ] 3. Remote backend for Terraform state
- [ ] 4. CI/CD with GitHub Actions (OIDC)
- [ ] 5. k3s on the VM
- [ ] 6. Argo CD (GitOps)
- [ ] 7. PostgreSQL + pgvector (`app_db`, `vector_db`)
- [ ] 8. Secrets with Azure Key Vault
- [ ] 9. Verification with k9s
- [ ] 10. Final documentation

## About

Built by **Juan Diego Giraldo Ospina** ([@JuanDiego500-sys](https://github.com/JuanDiego500-sys))
as a learning and portfolio project. I used [Claude Code](https://claude.com/claude-code)
as a learning assistant: it explained concepts and reviewed my work, and I wrote and committed the code.

## License

[MIT](LICENSE)