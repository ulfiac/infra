# codeconnections

Terraform module to create a GitHub CodeConnections connection. After applying, complete the GitHub authorization in the AWS Console before using the connection with downstream services.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.17.2 |
| aws | 6.73.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codeconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/6.73.0/docs/resources/codeconnections_connection) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| github\_connection\_arn | The ARN of the GitHub connection |
| github\_connection\_status | The status of the GitHub connection |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
