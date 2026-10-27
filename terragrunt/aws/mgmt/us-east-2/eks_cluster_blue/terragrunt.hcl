include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/eks_cluster.hcl"
}

dependency "eks_vpc" {
  config_path = "../eks_vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-12345678", "subnet-87654321"]
  }
}

inputs = {
  eks_cluster_name   = "blue"
  private_subnet_ids = dependency.eks_vpc.outputs.private_subnet_ids
}
