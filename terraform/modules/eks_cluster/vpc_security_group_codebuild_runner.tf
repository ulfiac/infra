resource "aws_security_group" "https_from_eks_runner" {
  name        = local.name_vpc_security_group_https_from_eks_runner
  description = "Security group to allow inbound https from the EKS runner"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "https_from_eks_runner" {
  security_group_id            = aws_security_group.https_from_eks_runner.id
  referenced_security_group_id = var.eks_runner_security_group_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "allow inbound https from eks runner"
}
