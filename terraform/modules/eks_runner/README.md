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
| [aws_cloudwatch_log_group.eks_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.eks_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/codebuild_project) | resource |
| [aws_codebuild_webhook.eks_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/codebuild_webhook) | resource |
| [aws_iam_policy.eks_runner_service_role](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_runner_service_role_terraform](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.eks_runner_service_role](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_runner_service_role](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_runner_service_role_ecr](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_runner_service_role_terraform](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.eks_runner](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.eks_runner_egress](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/caller_identity) | data source |
| [aws_codestarconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/codestarconnections_connection) | data source |
| [aws_iam_policy.amazon_ec2_container_registry_read_only](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.codebuild_runner_assume_role](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_runner_service_role](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_runner_service_role_terraform](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/region) | data source |
| [aws_s3_bucket.terraform_state](https://registry.terraform.io/providers/hashicorp/aws/6.72.0/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| github\_connection\_arn | The ARN of the GitHub code connection used by the CodeBuild runner | `string` | n/a | yes |
| image | The Docker image used by the CodeBuild runner | `string` | `"ghcr.io/ulfiac/terra-runner:1.2.1@sha256:cafa47ae39e7f86577c43a2cdf69d8a0b6bee91ec4f93b370890c420ed91ddfa"` | no |
| private\_subnet\_ids | The IDs of the private subnets in the VPC | `set(string)` | n/a | yes |
| verify\_github\_connection | Look up the GitHub connection and require it to be AVAILABLE. Disable only for mock-backed plans where the connection does not exist yet. | `bool` | `true` | no |
| vpc\_id | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_id | The ID of the security group for the CodeBuild runner |
| service\_role\_arn | The ARN of the service role for the CodeBuild runner |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
