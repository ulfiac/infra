include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/user.hcl"
  expose = true
}

dependencies {
  paths = ["../account_password_policy"]
}

terraform {
  source = "${include.component.locals.source_path}"
}

inputs = {
  default_group_name                    = "default-group-new"
  default_group_policy_name_enforce_mfa = "enforce-mfa-new"
  default_group_policy_name_roleswitch  = "role-switch-new"

  role_name_roleswitch_admin     = "role-switch-admin-new"
  role_name_roleswitch_poweruser = "role-switch-power-user-new"

  user_name = "actual-new"
}
