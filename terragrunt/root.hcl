# https://github.com/gruntwork-io/terragrunt-infrastructure-live-stacks-example/blob/main/root.hcl

locals {
  provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  account_vars  = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars   = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  merged_vars = merge(
    local.provider_vars.locals,
    local.account_vars.locals,
    local.region_vars.locals,
  )

  # in the merge into merged_vars above each aws_default_tags map will overwrite the previous map, so we need to merge the maps separately in their own merge function
  # this ensures the maps are merged instead of overwritten
  # also, we use try() to avoid errors if any of the aws_default_tags maps are not defined
  merged_aws_default_tags = merge(
    try(local.provider_vars.locals.aws_default_tags, {}),
    try(local.account_vars.locals.aws_default_tags, {}),
    try(local.region_vars.locals.aws_default_tags, {}),
  )
}

generate "provider_aws" {
  path      = "provider_aws.tf"
  disable   = !contains(local.merged_vars.providers, "aws")
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  allowed_account_ids = ["${local.merged_vars.aws_account_id}"]
  region              = "${local.merged_vars.aws_region}"

  default_tags {
    tags = {
    %{for key, value in local.merged_aws_default_tags}
      ${key} = "${value}"
    %{endfor}
    }
  }
}
EOF
}

generate "provider_github" {
  path      = "provider_github.tf"
  disable   = !contains(local.merged_vars.providers, "github")
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "github" {}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket       = "terraform-state-${local.merged_vars.aws_account_id}-${local.merged_vars.aws_region}"
    encrypt      = true
    key          = "${path_relative_to_include()}/tf.tfstate"
    region       = local.merged_vars.aws_region
    use_lockfile = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = local.merged_vars
