# mobile_user

Terraform module to create a dedicated, low-privilege IAM user for signing in to the AWS Console Mobile App to receive
push notifications (via AWS User Notifications) for CloudWatch alarms.  These resources include:

- user (`mobile-notifications`) with a console password encrypted with the regular user's PGP public key
- group (`mobile-notifications-group`) which the user is made a member of
- customer-inline policy attached to the group to allow the user to manage their own password and MFA device, and to
  deny everything else unless signed in with MFA
- customer-managed policy attached to the group to allow subscribing the mobile device to notification configurations
  and to view notifications, CloudWatch alarms/metrics/dashboards (not log contents), and costs
- customer-managed policy attached to the group with explicit denies for role assumption, long-lived credentials, IAM
  changes outside the user itself, and changes to alarms and notifications

The MFA enforcement policy is inline because trivy's AVD-AWS-0123 check (MFA enforced for group) only evaluates a
group's inline policy and its first policy attachment.  The other policies are customer-managed because all inline
policies on a group share a 5,120 character limit.

This user is intentionally separate from the regular user (see the `user` module).  The mobile device stores this
user's password (and possibly its MFA authenticator), so a lost or compromised device only exposes notifications and
read-only views, not admin access.

## First-time setup

1. decrypt the mobile user's password
    1. find the ```encrypted_password``` output from the terragrunt apply of ```_global/mobile_user```
    2. set it to a shell variable
        - ```encrypted_password="<encrypted password string>"```
    3. decrypt the password
        - ```echo $encrypted_password | base64 -d | gpg --decrypt```
2. in a desktop browser private window, sign in to the AWS Management Console as ```mobile-notifications``` and change the password (forced)
    - this sign-in happens before MFA exists, so the ```console-login-without-mfa``` alarm is expected to fire
3. configure MFA on the mobile user, then sign out and back in with MFA
4. install the AWS Console Mobile App, choose "Use an AWS identity", and sign in as ```mobile-notifications```
    - enable biometric authentication and save the password to the device's password manager
5. in the app, choose "Notifications", "Agree", "Allow", "Select existing", then choose "+" next to the notification configuration(s) to subscribe to (e.g. ```cloudwatch-alarms-from-cloudtrail```)
6. allow the AWS Console Mobile App through the device's Focus / Do Not Disturb settings
7. test from a desktop as the regular user (with the admin role)
    - ```aws cloudwatch set-alarm-state --region us-east-2 --alarm-name root-user-activity --state-value ALARM --state-reason "push test"```
    - a push notification (and an email from the SNS topic) should be received
8. look in CloudTrail for ```AccessDenied``` errors from ```mobile-notifications``` and add any missing read actions to the app access policy

## Lost or stolen device

From a desktop, as the regular user (with the admin role):

1. remove the mobile user's console access
    - ```aws iam delete-login-profile --user-name mobile-notifications```
2. deactivate and delete the mobile user's MFA device
    - ```aws iam list-mfa-devices --user-name mobile-notifications```
    - ```aws iam deactivate-mfa-device --user-name mobile-notifications --serial-number <serial number>```
    - ```aws iam delete-virtual-mfa-device --serial-number <serial number>```
3. remove the device as a delivery channel in the AWS User Notifications console ("Delivery channels")
4. remote wipe the device via your Apple or Google account
5. re-apply ```_global/mobile_user``` to recreate the login profile (new encrypted password), then repeat the first-time setup on the new device

## Notes

- The account password policy (see the `account_password_policy` module) applies to this user, so its password expires periodically.
- The mobile device's subscription (channel association) is created by the app, not by Terraform.  If a subscribed notification configuration is ever destroyed and recreated, re-subscribe in the app.
- The Cost Explorer API used by the app's Cost Management widget is charged per request.

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
| [aws_iam_group.mobile_user](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_group) | resource |
| [aws_iam_group_policy.self_manage](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.app_access](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.guardrails](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.app_access](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.guardrails](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_policy) | resource |
| [aws_iam_user.mobile_user](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_user) | resource |
| [aws_iam_user_group_membership.mobile_user](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_user_group_membership) | resource |
| [aws_iam_user_login_profile.mobile_user](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/resources/iam_user_login_profile) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.app_access](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.guardrails](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.self_manage](https://registry.terraform.io/providers/hashicorp/aws/6.68.0/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| group\_name | The name of the group the mobile user is made a member of. | `string` | `"mobile-notifications-group"` | no |
| pgp\_key | The base64 encoded binary PGP public key used to encrypt the mobile user's initial password. | `string` | n/a | yes |
| policy\_name\_app\_access | The name of the customer-managed policy that grants access to push notifications, CloudWatch alarms, and costs in the AWS Console Mobile App. | `string` | `"mobile-notifications-app-access"` | no |
| policy\_name\_guardrails | The name of the customer-managed policy that explicitly denies privilege escalation and tampering with alarms and notifications. | `string` | `"mobile-notifications-guardrails"` | no |
| policy\_name\_self\_manage | The name of the inline group policy that allows the mobile user to manage their own password and MFA device and enforces MFA. | `string` | `"mobile-notifications-self-manage"` | no |
| user\_name | The name of the mobile user to be created. | `string` | `"mobile-notifications"` | no |
| user\_password\_length | The length of the mobile user's password. | `number` | `42` | no |
| user\_password\_reset\_required | Whether the mobile user is required to reset their password on first login. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| encrypted\_password | encrypted password of the mobile user |
| group\_name | name of the group the mobile user is a member of |
| user\_arn | ARN of the mobile user |
| user\_name | name of the mobile user |
<!-- END_TF_DOCS -->

## Updating This README

Run the following command to update the inputs & outputs documentation:

```shell
terraform-docs markdown . --anchor=false --output-file=README.md
```
