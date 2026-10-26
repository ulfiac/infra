# eks-cluster

Terraform module to create an EKS cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.16.6 |
| aws | 6.69.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.69.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/eks_cluster) | resource |
| [aws_iam_role.eks](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy.amazon_eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.eks_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eks\_cluster\_name | The name of the EKS cluster | `string` | n/a | yes |
| eks\_version | The version of the EKS cluster | `string` | n/a | yes |
| private\_subnet\_ids | The IDs of the private subnets for the EKS cluster | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
