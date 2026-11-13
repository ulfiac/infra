resource "aws_codebuild_project" "runner_linux_arm64" {
  name         = local.name_codebuild_runner_linux_arm64
  service_role = var.iam_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM" # 8 GiB memory / 4 vCPUs / 128 GB disk space
    host_kernel  = "LINUX_KERNEL_6"        # kernel-6, Amazon Linux 2023
    image        = "aws/codebuild/amazonlinux-aarch64-standard:4.0"
    type         = "ARM_CONTAINER"
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/ulfiac/infra.git"

    auth {
      type     = "CODECONNECTIONS"
      resource = var.github_connection_arn
    }
  }

  vpc_config {
    vpc_id             = var.vpc_id
    security_group_ids = [aws_security_group.codebuild_runner.id]
    subnets            = var.private_subnet_ids
  }

  lifecycle {
    precondition {
      condition     = !var.verify_github_connection || one(data.aws_codestarconnections_connection.github[*].connection_status) == "AVAILABLE"
      error_message = "GitHub connection ${var.github_connection_arn} is ${coalesce(one(data.aws_codestarconnections_connection.github[*].connection_status), "not checked")}, not AVAILABLE; complete the pending authorization in the AWS console."
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.codebuild_runner,
    aws_vpc_security_group_egress_rule.codebuild_runner_egress,
  ]
}

resource "aws_codebuild_webhook" "runner_linux_arm64" {
  project_name = aws_codebuild_project.runner_linux_arm64.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    }
  }
}
