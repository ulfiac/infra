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

  # the user's own user ARN and virtual MFA devices are excluded so the user can still change their password and manage MFA
  statement {
    sid    = "DenyIamWritesOutsideSelf"
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
    not_resources = [
      "arn:aws:iam::${local.aws_account_id}:mfa/*",
      "arn:aws:iam::${local.aws_account_id}:user/$${aws:username}", # $$ needed so the $ is not interpreted by terraform
    ]
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
  description = "Explicitly denies the mobile user role assumption, long-lived credentials, IAM changes outside itself, and changes to alarms and notifications."
  policy      = data.aws_iam_policy_document.guardrails.json
}

resource "aws_iam_group_policy_attachment" "guardrails" {
  group      = aws_iam_group.mobile_user.name
  policy_arn = aws_iam_policy.guardrails.arn
}
