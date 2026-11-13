locals {
  aws_region = data.aws_region.current.region

  name_codebuild_runner_linux_arm64        = "eks-runner-infra-${local.aws_region}"
  name_vpc_security_group_codebuild_runner = "eks-runner-infra-${local.aws_region}"
}
