locals {
  source_path = "${dirname(find_in_parent_folders("root.hcl"))}/_modules/repo"
}

inputs = {}
