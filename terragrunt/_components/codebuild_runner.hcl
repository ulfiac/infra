terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/codebuild_runner"
}

inputs = {}
