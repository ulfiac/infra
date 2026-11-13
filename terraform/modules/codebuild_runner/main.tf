locals {
  aws_region = data.aws_region.current.region

  name_codebuild_runner_linux_arm64        = "runner-${local.aws_region}"
  name_iam_role_codebuild_runner           = "role-switch-codebuild-runner"
  name_vpc_security_group_codebuild_runner = "codebuild-runner-${local.aws_region}"
}
