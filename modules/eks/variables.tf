variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name) <= 100 && can(regex("^[a-zA-Z0-9-]*$", var.cluster_name))
    error_message = "Cluster name must be <= 100 characters and contain only alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster and nodes will be created"
  type        = string
}

variable "cluster_subnet_ids" {
  description = "Subnet IDs for the EKS control-plane cross-account ENIs"
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Subnet IDs for the EKS managed node group"
  type        = list(string)
}

variable "enable_irsa" {
  description = "Create an IAM OIDC provider for IAM Roles for Service Accounts (IRSA)"
  type        = bool
  default     = true
}

variable "enable_ebs_csi_driver" {
  description = "Install the aws-ebs-csi-driver EKS addon (via IRSA), needed for any workload with a PersistentVolumeClaim backed by the gp2/gp3 EBS storage classes"
  type        = bool
  default     = true
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster/node group. Leave null to let AWS assign its current default version (recommended — avoids pinning to a version that ages out of Auto Mode/other feature support)."
  type        = string
  default     = null
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_size > 0
    error_message = "Desired size must be greater than 0."
  }
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5

  validation {
    condition     = var.max_size > 0
    error_message = "Max size must be greater than 0."
  }
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.min_size > 0
    error_message = "Min size must be greater than 0."
  }
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default     = {}
}
