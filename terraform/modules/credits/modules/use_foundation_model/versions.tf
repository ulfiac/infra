terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.8.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.9.1"
    }
  }
  required_version = "1.16.2"
}
