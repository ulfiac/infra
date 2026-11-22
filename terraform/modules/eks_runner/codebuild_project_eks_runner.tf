resource "aws_codebuild_project" "eks_runner" {
  name         = local.name_codebuild_project
  service_role = aws_iam_role.eks_runner_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM" # 8 GiB memory / 4 vCPUs / 128 GB disk space
    host_kernel  = "LINUX_KERNEL_6"        # kernel-6, Amazon Linux 2023
    image        = var.image
    type         = "ARM_CONTAINER"

    environment_variable {
      name  = "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"
      value = "1"
    }
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
    security_group_ids = [aws_security_group.eks_runner.id]
    subnets            = var.private_subnet_ids
  }

  lifecycle {
    precondition {
      condition     = !var.verify_github_connection || one(data.aws_codestarconnections_connection.github[*].connection_status) == "AVAILABLE"
      error_message = "GitHub connection ${var.github_connection_arn} is ${coalesce(one(data.aws_codestarconnections_connection.github[*].connection_status), "not checked")}, not AVAILABLE; complete the pending authorization in the AWS console."
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.eks_runner,
    aws_iam_role_policy_attachment.eks_runner_service_role,
    aws_iam_role_policy_attachment.eks_runner_service_role_ecr,
    aws_iam_role_policy_attachment.eks_runner_service_role_terraform,
    aws_vpc_security_group_egress_rule.eks_runner_egress,
  ]
}

resource "aws_codebuild_webhook" "eks_runner" {
  project_name = aws_codebuild_project.eks_runner.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    }
  }
}
