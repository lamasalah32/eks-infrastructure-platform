variable "namespace" {
  description = "Namespace to install the AWS Load Balancer Controller into"
  type        = string
  default     = "kube-system"
}

variable "cluster_name" {
  description = "Name of the EKS cluster the controller manages load balancers for"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID the EKS cluster runs in"
  type        = string
}

variable "aws_region" {
  description = "AWS region the EKS cluster runs in"
  type        = string
  default     = "us-east-1"
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS cluster's IAM OIDC provider (for IRSA trust policy)"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the EKS cluster's OIDC issuer (for IRSA trust policy)"
  type        = string
}

variable "chart_version" {
  description = "Version of the aws-load-balancer-controller Helm chart"
  type        = string
  default     = "1.11.0"
}

variable "controller_image_tag" {
  description = "Image tag for the aws-load-balancer-controller container"
  type        = string
  default     = "v2.11.0"
}

variable "tags" {
  description = "Map of tags applied to the IAM role"
  type        = map(string)
  default     = {}
}
