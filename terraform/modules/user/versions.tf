terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.9.1"
    }
  }
  required_version = "1.17.0"
}
