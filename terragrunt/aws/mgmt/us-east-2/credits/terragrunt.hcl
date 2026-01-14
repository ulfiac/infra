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
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/credits"
}

inputs = {}
