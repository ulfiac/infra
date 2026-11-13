data "aws_codestarconnections_connection" "github" {
  name = "github"
}

data "aws_iam_policy" "administrator_access_policy" {
  name = "AdministratorAccess"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
