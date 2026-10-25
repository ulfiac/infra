terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/eks_cluster"
}

inputs = {
  eks_version = "1.37"
}
