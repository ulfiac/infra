# eks-vpc

Terraform module to create the VPC networking components needed for EKS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.16.0 |
| aws | 6.62.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.62.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_flow_log.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/flow_log) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/internet_gateway) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/route) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/route_table_association) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/resources/vpc) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.62.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| log\_bucket\_arn | ARN of the S3 bucket to store logs | `string` | n/a | yes |
| namespace | The namespace for the VPC. | `string` | `"eks"` | no |
| public\_subnets | Map of availability zones to public subnet CIDR blocks. | `map(string)` | n/a | yes |
| vpc\_cidr\_block | The CIDR block for the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| public\_route\_table\_id | The ID of the shared public route table |
| public\_subnet\_ids | Map of availability zone to public subnet ID |
| vpc\_id | The ID of the VPC |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
