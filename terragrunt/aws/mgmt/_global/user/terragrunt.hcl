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
  source = "${include.component.locals.source_url}?ref=${include.root.locals.merged_vars.source_version}"
}

inputs = {}
