variable "namespace" {
  description = "Namespace to install Atlantis into"
  type        = string
  default     = "atlantis"
}

variable "cluster_name" {
  description = "EKS cluster name (used for tagging/labeling only)"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS cluster's IAM OIDC provider (module.eks outputs.oidc_provider_arn) — used to build the IRSA trust policy for Atlantis's pod IAM role"
  type        = string
}

variable "oidc_provider_url" {
  description = "Issuer URL of the EKS cluster's OIDC provider, including the https:// scheme (module.eks outputs.cluster_oidc_issuer_url)"
  type        = string
}

variable "atlantis_chart_version" {
  description = "Version of the atlantis Helm chart (verify latest at artifacthub.io/packages/helm/atlantis/atlantis)"
  type        = string
  default     = "6.9.3"
}

variable "atlantis_image_repository" {
  description = "Container image for the Atlantis server"
  type        = string
  default     = "ghcr.io/runatlantis/atlantis"
}

variable "atlantis_image_tag" {
  description = "Tag of the Atlantis server image (verify latest at github.com/runatlantis/atlantis/releases)"
  type        = string
  default     = "v0.46.0"
}

variable "terragrunt_version" {
  description = "Version of the terragrunt binary to install into the Atlantis image via an init container (verify latest at github.com/gruntwork-io/terragrunt/releases) — the official Atlantis image bundles terraform but not terragrunt"
  type        = string
  default     = "1.1.0"
}

variable "vcs_provider_user" {
  description = "GitHub username Atlantis authenticates as (a bot/service account is recommended)"
  type        = string
}

variable "vcs_provider_token" {
  description = "GitHub personal access token for the Atlantis VCS user (repo scope). Pass via an environment variable at apply time (e.g. Terragrunt inputs sourced from get_env()) — never commit this."
  type        = string
  sensitive   = true
}

variable "vcs_webhook_secret" {
  description = "Shared secret configured on the GitHub webhook, used by Atlantis to verify webhook payloads. Pass via an environment variable at apply time — never commit this."
  type        = string
  sensitive   = true
}

variable "repo_allowlist" {
  description = "Comma-separated list of repos Atlantis is allowed to run on, e.g. \"github.com/my-org/my-repo\". Maps to the ATLANTIS_REPO_ALLOWLIST server flag."
  type        = string
}

variable "atlantis_url" {
  description = "External URL Atlantis reports back to GitHub in commit statuses/PR comments. Leave empty on first apply (before the LoadBalancer hostname is known); set it and re-apply once the Service's external hostname/DNS record exists."
  type        = string
  default     = ""
}

variable "service_type" {
  description = "Kubernetes Service type for the atlantis-server component"
  type        = string
  default     = "LoadBalancer"
}

variable "service_annotations" {
  description = "Annotations applied to the atlantis-server Service, provisioning an internet-facing NLB via the AWS Load Balancer Controller (modules/lb-controller must be applied first, or this Service stays pending)"
  type        = map(string)
  default = {
    "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
    "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    "service.beta.kubernetes.io/aws-load-balancer-scheme"          = "internet-facing"
  }
}

variable "iam_policy_arns" {
  description = "IAM policy ARNs attached to Atlantis's pod role (IRSA), granting it permission to apply the Terraform/Terragrunt changes it plans. Defaults to AdministratorAccess for simplicity in this learning/portfolio project — scope this down to least-privilege for real production use."
  type        = list(string)
}

variable "resources" {
  description = "Kubernetes resource requests/limits for the atlantis-server container"
  type = object({
    requests = optional(map(string), { cpu = "250m", memory = "512Mi" })
    limits   = optional(map(string), { cpu = "1", memory = "1Gi" })
  })
  default = {}
}

variable "tags" {
  description = "Tags applied to AWS resources created by this module"
  type        = map(string)
  default     = {}
}
