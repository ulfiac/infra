# iam_codebuild_runner

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.17.1 |
| aws | 6.72.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.72.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.codebuild_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codebuild_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_runner_ecr](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.amazon_ec2_container_registry_read_only](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.codebuild_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_runner_assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github\_connection\_arn | The ARN of the AWS CodeConnections (or CodeStar Connections) GitHub connection. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | The ARN of the IAM role for the CodeBuild runner |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
