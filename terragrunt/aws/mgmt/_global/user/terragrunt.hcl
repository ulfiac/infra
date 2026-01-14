include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/user.hcl"
  expose = true
}

dependencies {
  paths = ["../account_password_policy"]
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/user"
}

inputs = {}
