# vpc_default

Terraform module to adopt vpc-related resources into the terraform state.

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
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

No inputs.

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
