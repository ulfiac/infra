terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.0"
    }
  }
  required_version = "1.16.0"
}
