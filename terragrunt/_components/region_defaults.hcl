terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/region_defaults"
}

inputs = {}
