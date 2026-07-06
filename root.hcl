locals {
  account_id = get_aws_account_id()
}

remote_state {
  backend = "s3"

  config = {
    bucket       = "terraform-state-${local.account_id}"
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<-EOF
    terraform {
      required_version = ">= 1.10"
    }

    provider "aws" {
      region = "us-east-1"

      default_tags {
        tags = {
          ManagedBy   = "Terragrunt"
          Project     = "SRE-Mentorship"
        }
      }
    }
  EOF
}
