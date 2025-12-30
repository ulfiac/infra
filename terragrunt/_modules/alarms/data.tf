data "aws_caller_identity" "current" {}

data "aws_cloudwatch_log_group" "cloudtrail" {
  name = var.log_group_name_for_cloudtrail
}

# https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-sns-policy.html
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AWSBudgetsSNSPublishingPermissions"
    effect = "Allow"
    resources = [
      "arn:aws:sns:${local.aws_region}:${local.aws_account_id}:${local.sns_topic_name}",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }

    actions = [
      "SNS:Publish",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [data.aws_cloudwatch_log_group.cloudtrail.arn]
    }
  }
}

data "aws_region" "current" {}
