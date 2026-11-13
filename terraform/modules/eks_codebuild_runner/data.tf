data "aws_region" "current" {}

data "aws_codestarconnections_connection" "github" {
  count = var.verify_github_connection ? 1 : 0

  arn = var.github_connection_arn
}
