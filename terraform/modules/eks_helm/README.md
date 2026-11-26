# eks_helm

Terraform module to create applications in kubernetes using helm.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.17.2 |
| aws | 6.73.0 |
| helm | 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| helm | 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/3.3.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eks\_cluster\_name | The name of the EKS cluster | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
