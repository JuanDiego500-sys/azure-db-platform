# k8s

Kubernetes manifests that **Argo CD** watches and deploys to the k3s cluster.
Nothing here is applied by hand: a commit to `main` is a deployment.

Will contain (Phase 6–8):
- Argo CD `Application` definitions
- PostgreSQL with pgvector (`app_db`, `vector_db`)
- External Secrets Operator config to pull secrets from Azure Key Vault