data "aws_iam_policy" "view_only_access" {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "view_only_access" {
  group      = aws_iam_group.default_group.name
  policy_arn = data.aws_iam_policy.view_only_access.arn
}
