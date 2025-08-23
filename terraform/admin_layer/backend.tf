terraform {
  backend "s3" {
    bucket       = "terraform-state-ulfiac"
    encrypt      = true
    key          = "aws-bootstrap/admin_layer/us-east-2/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}
