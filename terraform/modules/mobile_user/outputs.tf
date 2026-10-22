output "encrypted_password" {
  description = "encrypted password of the mobile user"
  value       = aws_iam_user_login_profile.mobile_user.encrypted_password
}

output "group_name" {
  description = "name of the group the mobile user is a member of"
  value       = aws_iam_group.mobile_user.name
}

output "user_arn" {
  description = "ARN of the mobile user"
  value       = aws_iam_user.mobile_user.arn
}

output "user_name" {
  description = "name of the mobile user"
  value       = aws_iam_user.mobile_user.name
}
