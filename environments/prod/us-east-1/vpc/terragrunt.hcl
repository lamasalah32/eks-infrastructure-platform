include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  environment  = "prod"
  region       = "us-east-1"
  cluster_name = "eks-prod"
  cidr         = "10.20.0.0/16"
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]

  public_subnets  = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]
  private_subnets = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]

  tags = {
    Component = "VPC"
  }
}
