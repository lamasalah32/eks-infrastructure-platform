resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = var.namespace
  create_namespace = true

  values = [
    yamlencode({
      server = {
        service = {
          type = var.argocd_server_service_type
        }
      }
    })
  ]
}

resource "kubernetes_secret" "repo_credentials" {
  count = var.gitops_repo_ssh_private_key != "" ? 1 : 0

  metadata {
    name      = "gitops-repo-credentials"
    namespace = var.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    type          = "git"
    url           = var.gitops_repo_url
    sshPrivateKey = var.gitops_repo_ssh_private_key
  }

  depends_on = [helm_release.argocd]
}

resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = var.argocd_apps_chart_version
  namespace  = var.namespace

  values = [
    yamlencode({
      applications = {
        "app-of-apps" = {
          namespace = var.namespace
          project   = "default"
          source = {
            repoURL        = var.gitops_repo_url
            path           = var.gitops_repo_path
            targetRevision = var.gitops_target_revision
            directory = {
              recurse = true
            }
          }
          destination = {
            server    = "https://kubernetes.default.svc"
            namespace = var.namespace
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeal = true
            }
            syncOptions = ["CreateNamespace=true"]
          }
        }
      }
    })
  ]

  depends_on = [helm_release.argocd, kubernetes_secret.repo_credentials]
}
