data "aws_iam_policy_document" "assume_role_admin" {
  statement {
    sid     = "AllowAssumeRoleIfMFA"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = [aws_iam_user.regular_user.arn]
      type        = "AWS"
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role" "admin" {
  name                 = var.role_name_roleswitch_admin
  assume_role_policy   = data.aws_iam_policy_document.assume_role_admin.json
  max_session_duration = var.role_max_session_duration
}

data "aws_iam_policy" "admin_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin" {
  policy_arn = data.aws_iam_policy.admin_access.arn
  role       = aws_iam_role.admin.name
}

data "aws_iam_policy" "billing" {
  arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_role_policy_attachment" "billing" {
  policy_arn = data.aws_iam_policy.billing.arn
  role       = aws_iam_role.admin.name
}
