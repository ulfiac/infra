include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/credits.hcl"
  expose = true
}

dependencies {
  paths = ["../vpc_default"]
}

terraform {
  source = "${include.component.locals.source_url}?ref=${include.root.locals.merged_vars.source_version}"
}

inputs = {}
