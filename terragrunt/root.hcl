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
  merged_aws_default_tags = merge(
    local.provider_vars.locals.aws_default_tags,
    local.account_vars.locals.aws_default_tags,
    local.region_vars.locals.aws_default_tags,
  )
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

%{if contains(local.merged_vars.providers, "aws")}
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
%{endif}

%{if contains(local.merged_vars.providers, "github")}
provider "github" {}
%{endif}

EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
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

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = local.merged_vars
