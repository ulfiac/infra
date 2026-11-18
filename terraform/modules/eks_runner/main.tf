locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region

  name_codebuild_project                 = "eks-runner-infra-${local.aws_region}"
  name_iam_policy_service_role           = "eks-runner-infra-service-role-${local.aws_region}"
  name_iam_policy_service_role_terraform = "eks-runner-infra-service-role-terraform-${local.aws_region}"
  name_iam_role_service_role             = "eks-runner-infra-service-role-${local.aws_region}"
  name_vpc_security_group                = "eks-runner-infra-${local.aws_region}"
}
