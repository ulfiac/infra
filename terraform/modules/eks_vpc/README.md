# eks-vpc

Terraform module to create the VPC networking components needed for EKS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.16.1 |
| aws | 6.63.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.63.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/eip) | resource |
| [aws_flow_log.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/flow_log) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route) | resource |
| [aws_route_table.isolated](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route_table) | resource |
| [aws_route_table_association.isolated](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/route_table_association) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/resources/vpc) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.63.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| isolated\_subnets | Map of availability zones to isolated subnet CIDR blocks. | `map(string)` | n/a | yes |
| log\_bucket\_arn | ARN of the S3 bucket to store logs | `string` | n/a | yes |
| namespace | The namespace for the VPC. | `string` | `"eks"` | no |
| private\_subnets | Map of availability zones to private subnet CIDR blocks. | `map(string)` | n/a | yes |
| public\_subnets | Map of availability zones to public subnet CIDR blocks. | `map(string)` | n/a | yes |
| vpc\_cidr\_block | The CIDR block for the VPC. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| isolated\_route\_table\_id | The ID of the shared isolated route table |
| isolated\_subnet\_ids | List of isolated subnet IDs |
| isolated\_subnet\_ids\_map | Map of availability zone to isolated subnet ID |
| private\_route\_table\_id | The ID of the shared private route table |
| private\_subnet\_ids | List of private subnet IDs |
| private\_subnet\_ids\_map | Map of availability zone to private subnet ID |
| public\_route\_table\_id | The ID of the shared public route table |
| public\_subnet\_ids | List of public subnet IDs |
| public\_subnet\_ids\_map | Map of availability zone to public subnet ID |
| vpc\_id | The ID of the VPC |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
