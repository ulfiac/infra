# region_defaults

Terraform module to set various region defaults.  This includes:

1 - adopting the default vpc
2 - adopting the default subnets
3 - setting the default ebs encryption

## Usage Instructions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.14.2 |
| aws | >= 6.26.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 6.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_subnet.adopted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet) | resource |
| [aws_default_vpc.adopted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_ebs_default_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_default_kms_key) | resource |
| [aws_ebs_encryption_by_default.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_default\_ebs\_encryption | Enable default EBS encryption for the region | `bool` | `true` | no |
| prefix | Prefix for naming resources | `string` | `"default"` | no |
| verbose\_output | Enable verbose output for debugging purposes | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| adopted\_subnets | The adopted default subnets |
| adopted\_vpc | The adopted default VPC |
| data\_availability\_zones\_available | The available AWS availability zones data source |
| data\_aws\_region\_current | The current AWS region data source |
| data\_aws\_subnet\_default | The default subnet data source |
| data\_aws\_subnets\_default | The default subnets data source |
| data\_aws\_vpc\_default | The default VPC data source |
| local\_availability\_zones | The calculated availability zones |
| local\_region | The calculated region |
<!-- END_TF_DOCS -->

## Contributing

## License

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
