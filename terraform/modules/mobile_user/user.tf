resource "aws_iam_user" "mobile_user" {
  name          = var.user_name
  force_destroy = true
}

resource "aws_iam_user_login_profile" "mobile_user" {
  pgp_key                 = var.pgp_key
  password_length         = var.user_password_length
  password_reset_required = var.user_password_reset_required
  user                    = aws_iam_user.mobile_user.name
}

resource "aws_iam_user_group_membership" "mobile_user" {
  groups = [aws_iam_group.mobile_user.name]
  user   = aws_iam_user.mobile_user.name
}
