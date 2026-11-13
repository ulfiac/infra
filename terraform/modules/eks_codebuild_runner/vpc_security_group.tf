resource "aws_security_group" "codebuild_runner" {
  name        = local.name_vpc_security_group_codebuild_runner
  description = "EKS runner in CodeBuild"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "codebuild_runner_egress" {
  security_group_id = aws_security_group.codebuild_runner.id

  description = "allow outbound"
  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
