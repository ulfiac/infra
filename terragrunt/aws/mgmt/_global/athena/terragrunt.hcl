include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/athena.hcl"
  expose = true
}

dependency "logs" {
  config_path = "../logs"

  mock_outputs = {
    bucket_name = "logs-${include.root.locals.merged_vars.aws_account_id}-${include.root.locals.merged_vars.aws_region}"
    key_prefixes = {
      athena     = "athena"
      cloudtrail = "cloudtrail"
    }
  }
}

terraform {
  source = "${include.component.locals.source_url}?ref=${include.root.locals.merged_vars.source_version}"
}

inputs = {
  bucket_name  = dependency.logs.outputs.bucket_name
  key_prefixes = dependency.logs.outputs.key_prefixes
}
