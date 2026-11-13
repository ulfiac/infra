resource "aws_security_group" "codebuild_runner" {
  name        = local.name_vpc_security_group_codebuild_runner
  description = "Security group for CodeBuild runner"
  vpc_id      = data.aws_vpc.default.id

  ingress = []

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
