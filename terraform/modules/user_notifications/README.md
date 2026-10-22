# user

Terraform module to create a User Notifications notification hub that is required in order for other modules to setup
notification configurations to enable push notifications to the AWS Console Mobile App.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | 1.16.5 |
| aws | 6.68.0 |

## Providers

| Name | Version |
|------|---------|
| aws | 6.68.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_notifications_notification_hub.hub](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/notifications_notification_hub) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
