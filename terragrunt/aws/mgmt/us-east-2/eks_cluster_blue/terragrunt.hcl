include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/eks_cluster.hcl"
}

dependency "eks_codebuild_runner" {
  config_path = "../eks_codebuild_runner"
  mock_outputs = {
    security_group_id = "sg-01234567890abcdef"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show", "destroy"]
}

dependency "eks_vpc" {
  config_path = "../eks_vpc"
  mock_outputs = {
    private_subnet_ids = ["subnet-01234567890abcdef", "subnet-abcdef01234567890"]
    vpc_id             = "vpc-01234567890abcdef"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show", "destroy"]
}

inputs = {
  codebuild_runner_security_group_id = dependency.eks_codebuild_runner.outputs.security_group_id
  eks_cluster_name                   = "blue"
  private_subnet_ids                 = dependency.eks_vpc.outputs.private_subnet_ids
  vpc_id                             = dependency.eks_vpc.outputs.vpc_id
}
