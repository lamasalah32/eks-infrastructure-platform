include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "vpc-00000000000000000"
    private_subnet_id = ["subnet-00000000000000001", "subnet-00000000000000002"]
    public_subnet_id  = ["subnet-00000000000000003", "subnet-00000000000000004"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
}

inputs = {
  cluster_name   = "eks-dev"
  environment    = "dev"
  desired_size   = 2
  max_size       = 3
  min_size       = 2
  instance_types = ["t3.medium"]

  vpc_id             = dependency.vpc.outputs.vpc_id
  cluster_subnet_ids = dependency.vpc.outputs.private_subnet_id
  node_subnet_ids    = dependency.vpc.outputs.private_subnet_id

  tags = {
    Component = "EKS"
    Cluster   = "eks-dev"
  }
}
