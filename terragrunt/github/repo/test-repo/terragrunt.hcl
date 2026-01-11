include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/repo.hcl"
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/repo"
}

inputs = {
  name        = "test-repo"
  description = "This is a test repository"
}
