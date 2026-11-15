locals {
  aws_account_id = data.aws_caller_identity.current.account_id

  name_iam_policy_codebuild_runner = "codebuild-runner"
  name_iam_role_codebuild_runner   = "role-switch-codebuild-runner"
}
