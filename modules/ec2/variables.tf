variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instance and security group will be created"
  type        = string
}

variable "sg_name" {
  description = "sg name"
  type        = string
  default     = "terraform-vm"
}

