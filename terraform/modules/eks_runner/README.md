# codebuild_runner

Terraform module to create projects to be used as GitHub self-hosted runners.

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
| [aws_cloudwatch_log_group.codebuild_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.runner_linux_arm64](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/codebuild_project) | resource |
| [aws_codebuild_webhook.runner_linux_arm64](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/codebuild_webhook) | resource |
| [aws_security_group.codebuild_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.codebuild_runner_egress](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_codestarconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/codestarconnections_connection) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github\_connection\_arn | The ARN of the GitHub code connection used by the CodeBuild runner | `string` | n/a | yes |
| iam\_role\_arn | The ARN of the IAM role used by the CodeBuild runner | `string` | n/a | yes |
| private\_subnet\_ids | The IDs of the private subnets in the VPC | `list(string)` | n/a | yes |
| verify\_github\_connection | Look up the GitHub connection and require it to be AVAILABLE. Disable only for mock-backed plans where the connection does not exist yet. | `bool` | `true` | no |
| vpc\_id | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_id | The ID of the security group for the CodeBuild runner |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
