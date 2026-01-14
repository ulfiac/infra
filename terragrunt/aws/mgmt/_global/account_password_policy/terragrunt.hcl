include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/account_password_policy.hcl"
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/account_password_policy"
}

inputs = {}
