include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/codebuild_runner.hcl"
}

dependency "region_defaults" {
  config_path = "../region_defaults"
}

inputs = {}
