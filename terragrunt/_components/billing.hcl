locals {
  source_path = "${dirname(find_in_parent_folders("root.hcl"))}/_modules/billing"
  # source_url     = "git::https://github.com/ulfiac/terraform-infrastructure-modules.git//modules/billing"
  # source_version = "main"
}

inputs = {}
