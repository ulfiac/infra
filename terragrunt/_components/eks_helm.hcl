terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/_modules/eks_helm"
}

inputs = {}
