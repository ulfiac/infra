include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_components/alarms.hcl"
  expose = true
}

dependency "logs" {
  config_path = "../logs"

  mock_outputs = {
    log_group_name = "/aws/cloudtrail/multi-region-trail-${include.root.locals.merged_vars.aws_account_id}-${include.root.locals.merged_vars.aws_region}"
  }
}

terraform {
  source = "${include.component.locals.source_url}?ref=${include.root.locals.merged_vars.source_version}"
}

inputs = {
  log_group_name_for_cloudtrail = dependency.logs.outputs.log_group_name
}
