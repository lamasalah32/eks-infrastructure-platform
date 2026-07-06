include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  environment = "prod"
  aws_region  = "us-east-1"

  env_tags = {
    Environment = local.environment
    Tier        = "Production"
  }
}
