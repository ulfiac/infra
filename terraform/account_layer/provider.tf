module "tags" {
  source  = "../../terragrunt/_modules/tags"
  project = "aws-infrastructure"
  additional_tags = {
    layer = "account_layer"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = module.tags.all_the_tags
  }
}

provider "local" {}
