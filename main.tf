locals {
  log_group_name = "/aws/codebuild/${var.app_name}"
}

resource "aws_cloudwatch_log_group" "project_logs" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
  tags              = var.common_tags
}


resource "aws_codebuild_project" "project" {
  name          = var.app_name
  description   = "CodeBuild project for ${var.app_name}"
  tags          = var.common_tags
  build_timeout = "30"

  service_role  = var.service_role_arn

  source {
    type                = var.source_type
    location            = var.source_location
    git_clone_depth     = 1
    buildspec           = var.buildspec
    report_build_status = var.trigger_on_pr
    auth {
      type     = "OAUTH"
      resource = "arn:aws:secretsmanager:us-east-1:286005841113:secret:nodejs-demo-github-token-dRHXbL"
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = var.privileged_mode
    image_pull_credentials_type = "CODEBUILD"

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  vpc_config {
    vpc_id             = data.aws_vpc.selected.id
    subnets            = data.aws_subnets.default.ids
    security_group_ids = [aws_security_group.codebuild_sg.id]
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.project_logs.name
      stream_name = "build"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.project_logs
  ]
}

resource "aws_codebuild_webhook" "webhook" {
  project_name = aws_codebuild_project.project.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }
    filter {
      type    = "HEAD_REF"
      pattern = "refs/heads/main"
    }
  }

  dynamic "filter_group" {
    for_each = var.trigger_on_pr ? [1] : []
    content {
      filter {
        type    = "EVENT"
        pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
      }
    }
  }

}