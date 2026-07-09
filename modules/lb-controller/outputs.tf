output "iam_role_arn" {
  description = "ARN of the IAM role assumed by the aws-load-balancer-controller pod (IRSA)"
  value       = aws_iam_role.lb_controller.arn
}
