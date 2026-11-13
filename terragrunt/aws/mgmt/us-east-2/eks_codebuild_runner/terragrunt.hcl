locals {
  global_region              = read_terragrunt_config("${get_terragrunt_dir()}/../../_global/region.hcl").locals.aws_region
  mock_github_connection_arn = "arn:aws:codeconnections:${local.global_region}:${include.root.locals.merged_vars.aws_account_id}:connection/00000000-0000-0000-0000-000000000000"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/eks_codebuild_runner.hcl"
}

dependency "codeconnections" {
  config_path = "../../_global/codeconnections"
  mock_outputs = {
    github_connection_arn = local.mock_github_connection_arn
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show", "destroy"]
}

dependency "iam_codebuild_runner" {
  config_path = "../../_global/iam_codebuild_runner"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::${include.root.locals.merged_vars.aws_account_id}:role/codebuild-runner"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show", "destroy"]
}

dependency "eks_vpc" {
  config_path = "../eks_vpc"
  mock_outputs = {
    private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
    vpc_id             = "vpc-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "show", "destroy"]
}

inputs = {
  github_connection_arn    = dependency.codeconnections.outputs.github_connection_arn
  iam_role_arn             = dependency.iam_codebuild_runner.outputs.iam_role_arn
  private_subnet_ids       = dependency.eks_vpc.outputs.private_subnet_ids
  verify_github_connection = dependency.codeconnections.outputs.github_connection_arn != local.mock_github_connection_arn
  vpc_id                   = dependency.eks_vpc.outputs.vpc_id
}

