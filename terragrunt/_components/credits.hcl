locals {
  source_url     = "git::https://github.com/ulfiac/terraform-infrastructure-modules.git//modules/credits"
  source_version = "main"
}

inputs = {
  launch_an_instance_using_ec2 = false
}
