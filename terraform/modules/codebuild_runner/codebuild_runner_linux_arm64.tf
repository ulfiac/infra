resource "aws_codebuild_project" "runner_linux_arm64" {
  name         = local.name_codebuild_runner_linux_arm64
  service_role = aws_iam_role.codebuild_runner.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM" # 8 GiB memory / 4 vCPUs / 128 GB disk space
    # host_kernel  = "LINUX_KERNEL_LATEST"
    image = "aws/codebuild/amazonlinux-aarch64-standard:4.0"
    type  = "ARM_CONTAINER"
  }

  source {
    type     = "GITHUB"
    location = "https://github.com"

    auth {
      type     = "CODECONNECTIONS"
      resource = data.aws_codestarconnections_connection.github.arn
    }
  }

  vpc_config {
    vpc_id             = data.aws_vpc.default.id
    security_group_ids = [aws_security_group.codebuild_runner.id]
    subnets            = data.aws_subnets.default.ids
  }


  depends_on = [
    aws_cloudwatch_log_group.codebuild_runner,
    aws_iam_role_policy_attachment.codebuild_runner,
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
