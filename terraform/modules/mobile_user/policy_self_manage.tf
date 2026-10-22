data "aws_iam_policy_document" "self_manage" {

  # a trimmed version of the AWS example that lets users manage their own credentials with MFA
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage.html
  # unlike the regular user's enforce-mfa policy, this only allows managing the user's own password and MFA device
  # access keys, signing certificates, SSH public keys, and service-specific (git) credentials are intentionally not allowed

  statement {
    sid    = "AllowViewAccountInfo"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy", # view the account password requirements while changing their own IAM user password
      "iam:ListVirtualMFADevices",    # view details about a virtual MFA device that is enabled for the user
    ]
    resources = ["*"] # these permissions must be in their own statement because they do not support or do not need to specify a resource ARN
  }

  statement {
    sid    = "AllowManageOwnPassword"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:GetLoginProfile",
      "iam:GetUser",
    ]
    resources = ["arn:aws:iam::${local.aws_account_id}:user/$${aws:username}"] # $$ needed so the $ is not interpreted by terraform
  }

  statement {
    sid    = "AllowCreateVirtualMFADevice"
    effect = "Allow"
    actions = [
      "iam:CreateVirtualMFADevice",
    ]
    resources = ["arn:aws:iam::${local.aws_account_id}:mfa/*"]
  }

  statement {
    sid    = "AllowManageOwnUserMFA"
    effect = "Allow"
    actions = [
      "iam:DeactivateMFADevice",
      "iam:EnableMFADevice",
      "iam:GetMFADevice",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice",
    ]
    resources = ["arn:aws:iam::${local.aws_account_id}:user/$${aws:username}"] # $$ needed so the $ is not interpreted by terraform
  }

  # when the user is not signed in with MFA, deny everything except the actions needed to set up MFA
  # the not_actions list mirrors the regular user's enforce-mfa policy (minus iam:ListUsers)
  # the ...IfExists version of the Bool operator ensures that if the aws:MultiFactorAuthPresent key is missing, the condition returns true
  statement {
    sid    = "DenyAllExceptListedIfNoMFA"
    effect = "Deny"
    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:GetMFADevice",
      "iam:GetUser",
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
      "sts:GetSessionToken",
    ]
    resources = ["*"]
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

# inline (not customer-managed) so that trivy's AVD-AWS-0123 check sees the MFA enforcement
# trivy only evaluates a group's inline policy and its first policy attachment
resource "aws_iam_group_policy" "self_manage" {
  group  = aws_iam_group.mobile_user.name
  name   = var.policy_name_self_manage
  policy = data.aws_iam_policy_document.self_manage.json
}
