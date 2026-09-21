terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
  }
  required_version = "1.16.2"
}
