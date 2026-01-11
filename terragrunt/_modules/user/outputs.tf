output "encrypted_password" {
  description = "encrypted password of the regular user"
  value       = aws_iam_user_login_profile.regular_user.encrypted_password
}

output "pgp_public_key_content_sha256_checksum" {
  description = "SHA256 checksum of the PGP public key content"
  value       = data.local_file.pgp_public_key.content_sha256
}
