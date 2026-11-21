terraform {
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    aws = {
      source  = "hashicorp/aws"
      version = "6.73.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
  }
  required_version = "1.17.2"
}
