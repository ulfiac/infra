terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/account_password_policy"
}

inputs = {}
