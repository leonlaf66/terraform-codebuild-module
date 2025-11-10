output "project_arn" {
  description = "The ARN of the created CodeBuild project."
  value       = aws_codebuild_project.project.arn
}

output "project_name" {
  description = "The name of the created CodeBuild project."
  value       = aws_codebuild_project.project.name
}

output "project_log_group_name" {
  description = "The name of the CloudWatch Log Group for this project."
  value       = aws_cloudwatch_log_group.project_logs.name
}

