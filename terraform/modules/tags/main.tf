locals {

  standard_tags = {
    created_by = var.created_by
    repo       = var.repo
  }

  all_the_tags = merge(local.standard_tags, var.additional_tags)

}
