data "aws_iam_policy_document" "guardrails" {

  # explicit denies that apply even if a broader policy is attached to this user or group by mistake later

  statement {
    sid    = "DenyRoleAssumptionAndFederation"
    effect = "Deny"
    actions = [
      "sts:AssumeRole",
      "sts:AssumeRoleWithSAML",
      "sts:AssumeRoleWithWebIdentity",
      "sts:GetFederationToken",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "DenyLongLivedCredentials"
    effect = "Deny"
    actions = [
      "iam:CreateAccessKey",
      "iam:CreateLoginProfile",
      "iam:CreateServiceSpecificCredential",
      "iam:UpdateAccessKey",
      "iam:UpdateLoginProfile",
      "iam:UploadSigningCertificate",
      "iam:UploadSSHPublicKey",
    ]
    resources = ["*"]
  }

  # deny IAM writes on every resource, including the user itself, so the user can't grant itself policies, change its
  # permissions boundary, or otherwise modify itself; none of the password and MFA actions in the self-manage policy match
  # these wildcards, except iam:CreateVirtualMFADevice which needs the mfa/* exclusion
  statement {
    sid    = "DenyIamWrites"
    effect = "Deny"
    actions = [
      "iam:Add*",
      "iam:Attach*",
      "iam:Create*",
      "iam:Delete*",
      "iam:Detach*",
      "iam:Pass*",
      "iam:Put*",
      "iam:Remove*",
      "iam:Set*",
      "iam:Tag*",
      "iam:Untag*",
      "iam:Update*",
      "iam:Upload*",
    ]
    not_resources = ["arn:aws:iam::${local.aws_account_id}:mfa/*"]
  }

  # prevent a compromised mobile session from silencing the alarms and notifications that would detect misuse
  statement {
    sid    = "DenyChangingAlarmsAndNotifications"
    effect = "Deny"
    actions = [
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:SetAlarmState",
      "notifications:Create*",
      "notifications:Delete*",
      "notifications:DeregisterNotificationHub",
      "notifications:Update*",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "guardrails" {
  name        = var.policy_name_guardrails
  description = "Explicitly denies the mobile user role assumption, long-lived credentials, IAM changes (including to itself), and changes to alarms and notifications."
  policy      = data.aws_iam_policy_document.guardrails.json
}

resource "aws_iam_group_policy_attachment" "guardrails" {
  group      = aws_iam_group.mobile_user.name
  policy_arn = aws_iam_policy.guardrails.arn
}
