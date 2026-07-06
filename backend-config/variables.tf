variable "region" {
  description = "AWS region to create the Terraform state bucket in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 state bucket name; the AWS account ID is appended automatically"
  type        = string
  default     = "terraform-state"
}

variable "tags" {
  description = "Tags applied to the Terraform state bucket"
  type        = map(string)
  default = {
    Name        = "terraform-state"
    Environment = "shared"
    Purpose     = "Terraform State Storage"
  }
}
