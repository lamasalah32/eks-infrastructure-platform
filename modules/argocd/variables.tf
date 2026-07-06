variable "namespace" {
  description = "Namespace to install ArgoCD into"
  type        = string
  default     = "argocd"
}

variable "cluster_name" {
  description = "EKS cluster name (used for tagging/labeling only)"
  type        = string
}

variable "argocd_chart_version" {
  description = "Version of the argo-cd Helm chart (verify latest at artifacthub.io/packages/helm/argo/argo-cd)"
  type        = string
  default     = "7.7.11"
}

variable "argocd_apps_chart_version" {
  description = "Version of the argocd-apps Helm chart (verify latest at artifacthub.io/packages/helm/argo/argocd-apps)"
  type        = string
  default     = "2.0.2"
}

variable "argocd_server_service_type" {
  description = "Kubernetes service type for the argocd-server component"
  type        = string
  default     = "ClusterIP"
}

variable "gitops_repo_url" {
  description = "Git repository URL ArgoCD's bootstrap Application will sync from. Placeholder default — replace with the real GitOps repo once it exists."
  type        = string
  default     = "https://github.com/CHANGEME/gitops-repo.git"
}

variable "gitops_repo_path" {
  description = "Path within the GitOps repo containing the Application manifests for this environment"
  type        = string
  default     = "."
}

variable "gitops_target_revision" {
  description = "Git branch/tag/ref for ArgoCD to track"
  type        = string
  default     = "main"
}

variable "gitops_repo_ssh_private_key" {
  description = "SSH private key for a private GitOps repo. Leave empty for a public repo."
  type        = string
  default     = ""
  sensitive   = true
}
