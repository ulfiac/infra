# https://github.com/gruntwork-io/terragrunt-infrastructure-live-stacks-example/blob/main/root.hcl

locals {
  provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"))

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  merged_vars = merge(
    local.provider_vars.locals,
    local.account_vars.locals,
    local.region_vars.locals,
  )

  # Extract the variables we need for easy access
  providers      = local.merged_vars.providers
  aws_account_id = local.merged_vars.aws_account_id
  aws_region     = local.merged_vars.aws_region

  default_tags = {
    created_by = "terragrunt/terraform"
    repo       = "infrastructure"
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

%{if contains(local.providers, "aws")}
provider "aws" {
  allowed_account_ids = ["${local.aws_account_id}"]
  region              = "${local.aws_region}"

  default_tags {
    tags = {
      %{for key, value in local.default_tags}
        ${key} = "${value}"
      %{endfor}
    }
  }
}
%{endif}

%{if contains(local.providers, "github")}
provider "github" {}
%{endif}

EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    bucket       = "terraform-state-${local.aws_account_id}-${local.aws_region}"
    encrypt      = true
    key          = "${path_relative_to_include()}/tf.tfstate"
    region       = local.aws_region
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
