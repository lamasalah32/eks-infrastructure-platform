include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  environment  = "dev"
  region       = "us-east-1"
  cluster_name = "eks-dev"
  cidr         = "10.10.0.0/16"
  azs         = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.10.0.0/24", "10.10.1.0/24"]
  private_subnets = ["10.10.10.0/24", "10.10.11.0/24"]

  tags = {
    Component = "VPC"
  }
}
