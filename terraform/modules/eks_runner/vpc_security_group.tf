resource "aws_security_group" "eks_runner" {
  name        = local.name_vpc_security_group
  description = "EKS runner in CodeBuild"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "eks_runner_egress" {
  security_group_id = aws_security_group.eks_runner.id

  cidr_ipv4   = "0.0.0.0/0"
  description = "allow outbound"
  ip_protocol = "-1"
}
