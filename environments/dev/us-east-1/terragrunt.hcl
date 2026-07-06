include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  aws_region = "us-east-1"
}
