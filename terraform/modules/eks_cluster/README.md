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
| [aws_cloudwatch_log_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_access_entry.admin](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.admin](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_cluster.eks](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.bottlerocket_arm_64](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.bottlerocket_x86_64](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/eks_node_group) | resource |
| [aws_iam_role.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role) | resource |
| [aws_iam_role.eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_worker_node_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy.amazon_ec2_container_registry_read_only](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.amazon_eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.amazon_eks_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.amazon_eks_worker_node_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.eks_cluster_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_node_group_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.cluster_admin](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.69.1/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_admin\_role\_names | The names of the IAM roles that should have cluster admin access | `set(string)` | <pre>[<br/>  "role-switch-admin"<br/>]</pre> | no |
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
