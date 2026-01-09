include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/account_password_policy.hcl"
  expose = true
}

terraform {
  source = "${include.component.locals.source_url}?ref=${include.root.locals.merged_vars.source_version}"
}

inputs = {}
