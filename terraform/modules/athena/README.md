# athena

Terraform module to enable using Athena to query various types of logs stored in a centralized s3 bucket.  This is being done to facilitate troubleshooting.

This first iteration only includes an Athena table for the multi-region Cloudtrail trail built by the "logs" module.  Other Athena tables will follow for ALB logs, NLB logs, VPC flow logs, and Route53 logs.

## Usage Instructions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.1 |
| aws | >= 6.24.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_athena_database.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_workgroup.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) | resource |
| [aws_glue_catalog_table.cloudtrail_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_regions.enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |
| [aws_s3_bucket.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | The name of the S3 bucket where logs and Athena query results are stored. | `string` | n/a | yes |
| key\_prefixes | A map of S3 key prefixes for storing different types of logs and Athena query results. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
