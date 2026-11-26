include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/eks_helm.hcl"
}

dependency "eks_cluster" {
  config_path = "../../../../aws/mgmt/us-east-2/eks_cluster_blue"
  mock_outputs = {
    eks_cluster_name = "eks-placeholder"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "show"]
}

inputs = {
  eks_cluster_name = dependency.eks_cluster.outputs.eks_cluster_name
}
