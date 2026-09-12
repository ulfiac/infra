locals {
  aws_region = "us-east-2"

  eks_isolated_subnets = { # isolated subnet block 10.1.48.0/21
    "us-east-2a" = "10.1.48.0/23"
    "us-east-2b" = "10.1.50.0/23"
    "us-east-2c" = "10.1.52.0/23"
  }
  eks_private_subnets = { # private subnet block 10.1.40.0/21
    "us-east-2a" = "10.1.40.0/23"
    "us-east-2b" = "10.1.42.0/23"
    "us-east-2c" = "10.1.44.0/23"
  }
  eks_public_subnets = { # public subnet block 10.1.32.0/21
    "us-east-2a" = "10.1.32.0/23"
    "us-east-2b" = "10.1.34.0/23"
    "us-east-2c" = "10.1.36.0/23"
  }
  eks_vpc_cidr_block = "10.1.32.0/19" # region block 2 of 8: 10.1.0.0/16 split into 8 /19s

  enable_cloudtrail_logs = true
}
