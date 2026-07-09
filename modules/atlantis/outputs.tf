output "namespace" {
  description = "Namespace Atlantis was installed into"
  value       = var.namespace
}

output "atlantis_server_service" {
  description = "In-cluster DNS name of the atlantis-server service"
  value       = "${helm_release.atlantis.name}.${var.namespace}.svc.cluster.local"
}

output "iam_role_arn" {
  description = "ARN of the IAM role assumed by Atlantis pods via IRSA"
  value       = aws_iam_role.atlantis.arn
}
