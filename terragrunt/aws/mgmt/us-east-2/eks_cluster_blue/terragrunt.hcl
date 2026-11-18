include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/eks_cluster.hcl"
}

dependency "eks_runner" {
  config_path = "../eks_runner"
  mock_outputs = {
    security_group_id = "sg-01234567890abcdef"
    service_role_arn  = "arn:aws:iam::${include.root.locals.merged_vars.aws_account_id}:role/eks-runner-service-role"
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

dependency "user" {
  config_path = "../../_global/user"
  mock_outputs = {
    admin_role_arn = "arn:aws:iam::${include.root.locals.merged_vars.aws_account_id}:role/admin"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show", "destroy"]
}

inputs = {
  cluster_admin_role_arns = [
    dependency.user.outputs.admin_role_arn,
    dependency.eks_runner.outputs.service_role_arn,
  ]
  eks_cluster_name             = "blue"
  eks_runner_security_group_id = dependency.eks_runner.outputs.security_group_id
  private_subnet_ids           = dependency.eks_vpc.outputs.private_subnet_ids
  vpc_id                       = dependency.eks_vpc.outputs.vpc_id
}
