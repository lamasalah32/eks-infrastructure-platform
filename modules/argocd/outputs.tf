output "namespace" {
  description = "Namespace ArgoCD was installed into"
  value       = var.namespace
}

output "argocd_server_service" {
  description = "In-cluster DNS name of the argocd-server service"
  value       = "${helm_release.argocd.name}-server.${var.namespace}.svc.cluster.local"
}
