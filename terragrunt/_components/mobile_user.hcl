terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/mobile_user"
}

inputs = {
  # reuse the regular user's PGP public key to encrypt the mobile user's initial password
  pgp_key = file("${dirname(find_in_parent_folders("root.hcl"))}/../terraform/modules/user/public_key_binary_base64encoded.gpg")
}
