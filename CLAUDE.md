# Project: azure-db-platform

**Author:** Juan Diego Giraldo Ospina · GitHub: [JuanDiego500-sys](https://github.com/JuanDiego500-sys)
**Type:** portfolio and learning project (my first CI/CD + GitOps project)

## Goal

Demonstrate a complete CI/CD automation where **this repository is the source of truth**:

1. **Terraform** creates the infrastructure in Azure: a virtual machine and an Azure Key Vault.
2. **GitHub Actions** runs Terraform automatically (plan on Pull Requests, apply on merge to `main`).
3. The VM runs a lightweight Kubernetes (**k3s**) with **Argo CD** installed.
4. **Argo CD** watches this repo and automatically deploys **PostgreSQL** with two databases:
   - a regular relational database (`app_db`)
   - a vector database using the **pgvector** extension (`vector_db`)
5. **Secrets** (PostgreSQL passwords, etc.) are stored in **Azure Key Vault** and reach the cluster without ever being in the code.
6. I connect to the VM over SSH and verify everything with **k9s**.

## How I want to learn (rules for Claude)

I know how this works once it's built, but **I don't know how to build it**. I want to learn from scratch.

- **Explain before writing.** For every file: what it is, what it's for, and why it's done that way.
- **Work in phases.** Don't move to the next phase until I confirm.
- **Let me write the code when possible.** Propose the code, explain it, and if I ask, let me write it while you review.
- **Explain commands** before running them (what they do and what they could break).
- When something fails, help me **read the error** and understand the cause, not just fix it.
- At the end of each phase, give me a **short summary of what I learned** and ask me 2–3 questions to check my understanding.
- Communicate in English (I'm practicing). If I get stuck, I may ask in Spanish.

## Constraints

- **Budget:** Azure free account with USD 200 in credit (check the expiration date in the portal).
  - Use cheap SKUs (e.g. VM `Standard_B2s` or `B2ms`).
  - Remind me to **stop (deallocate) or destroy** the VM at the end of every session.
  - No AKS or expensive managed services: Kubernetes runs inside the VM with k3s.
- **Security:**
  - Never put secrets, passwords, SSH keys, or sensitive IDs in the code or in commits.
  - GitHub Actions authenticates to Azure with **OIDC** (no stored client secrets).
  - SSH to the VM with key only, restricted to my IP.
  - Terraform state lives in a remote backend (Azure Storage), not in the repo.
- **Free / open-source tools only** besides Azure (Argo CD, k3s, k9s, pgvector, External Secrets Operator).

## Architecture

```
GitHub (source of truth)
 ├── terraform/  ──► GitHub Actions ──► Azure: VM + Key Vault + network
 └── k8s/        ──► Argo CD (on the VM) ──► PostgreSQL (app_db + vector_db)
                                              ▲
                     Azure Key Vault ──► External Secrets Operator
```

## Phases

1. **Foundations:** repo structure, `README.md`, `LICENSE` (MIT under my name), Terraform `.gitignore`. Set up Azure CLI and Terraform in VS Code.
2. **Local Terraform:** resource group, network (VNet, subnet, NSG), Linux VM, and Key Vault. Learn `init`, `plan`, `apply`, `destroy`, variables, outputs, and modules.
3. **Remote backend:** store Terraform state in Azure Storage.
4. **CI/CD with GitHub Actions:** OIDC to Azure; `fmt` + `validate` + `plan` on PRs, `apply` on `main`, manual `destroy` workflow.
5. **Kubernetes on the VM:** install k3s (ideally via cloud-init from Terraform), connect over SSH, and use `kubectl` and **k9s**.
6. **Argo CD (GitOps):** install Argo CD and create an `Application` pointing to this repo's `k8s/` folder.
7. **PostgreSQL + pgvector:** manifests/Helm for PostgreSQL with pgvector, creating `app_db` and `vector_db`. Deployed by Argo CD, not by hand.
8. **Secrets with Key Vault:** store passwords in Azure Key Vault and sync them to the cluster with External Secrets Operator.
9. **Verification:** use k9s to check pods, logs, and secrets; connect to PostgreSQL and confirm `CREATE EXTENSION vector` works with a test query.
10. **Final documentation:** README with diagram, step-by-step guide, k9s and Argo CD screenshots, and a "What I learned" section.

## Conventions

- Suggested structure: `terraform/`, `k8s/`, `.github/workflows/`, `docs/`, `scripts/`.
- Small, descriptive commits in English (e.g. `feat(terraform): add key vault`).
- Each main folder has its own `README.md` explaining its contents.
- All documentation and code comments in English.
- I make the commits under my own name. The README mentions that I used Claude Code as a learning assistant.
