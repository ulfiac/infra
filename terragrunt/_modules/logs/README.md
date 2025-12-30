# logs

Terraform module to configure logging across all regions in the account.  This includes...

- a single s3 bucket to be a destination for various logs
- a multi-region cloudtrail trail that will log to the above s3 bucket to a specific s3 prefix
- an s3 prefix for alb logging
- an s3 prefix for route53 logging
- an athena database and tables to query logs collected in the s3 bucket

## Usage Instructions

This module should be called by the `_global` account/region because it is cross-region.

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
| [aws_cloudtrail.multi_region_trail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cloudtrail_to_cloudwatch_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudtrail_to_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_s3_bucket.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.key_prefixes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudtrail_to_cloudwatch_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cloudtrail_to_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| expire\_alb\_logs\_in\_days | Number of days after which ALB logs expire. | `number` | `30` | no |
| expire\_athena\_results\_in\_days | Number of days after which Athena query results expire. | `number` | `10` | no |
| expire\_cloudtrail\_logs\_in\_days | Number of days after which CloudTrail logs expire. | `number` | `30` | no |
| expire\_nlb\_logs\_in\_days | Number of days after which NLB logs expire. | `number` | `30` | no |
| expire\_noncurrent\_object\_versions\_in\_days | Number of days after which noncurrent object versions expire. | `number` | `10` | no |
| expire\_route53\_logs\_in\_days | Number of days after which Route53 logs expire. | `number` | `30` | no |
| expire\_vpc\_flow\_logs\_in\_days | Number of days after which VPC Flow logs expire. | `number` | `3` | no |
| log\_group\_retention\_in\_days | The number of days to retain log events in the specified log group. | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the logs S3 bucket |
| key\_prefixes | The S3 key prefixes for different log types |
| log\_group\_name | The name of the CloudWatch log group for CloudTrail |
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
