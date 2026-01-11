locals {
  source_url = "git::https://github.com/ulfiac/infra.git//terraform/modules/credits"
}

inputs = {
  create_lambda        = false
  create_rds_database  = false
  launch_ec2_instance  = false
  setup_cost_budget    = false
  use_foundation_model = false
}
