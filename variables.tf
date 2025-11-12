variable "app_name" {
  description = "A unique name for this CodeBuild project (e.g., 'my-app-a-build')."
  type        = string
}

variable "service_role_arn" {
  description = "The ARN of the shared IAM role (from the platform-infra project) to assign to this project."
  type        = string
}

variable "common_tags" {
  description = "A map of common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

# --- New Log Retention Variable ---
variable "log_retention_days" {
  description = "Number of days to retain logs in CloudWatch. 0 means never expire."
  type        = number
  default     = 30
}

# --- Source & Build ---
variable "source_type" {
  description = "Source type for the build project."
  type        = string
  default     = "GITHUB"
}

variable "source_location" {
  description = "The location of the source code (e.g., 'https://github.com/my-org/my-app.git')."
  type        = string
}

variable "buildspec" {
  description = "The name of the buildspec file."
  type        = string
  default     = "buildspec.yml"
}

variable "compute_type" {
  description = "Build instance compute type."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "image" {
  description = "Build instance image."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

variable "privileged_mode" {
  description = "Set to true if building Docker images."
  type        = bool
  default     = true
}

# --- Triggers ---
variable "trigger_on_pr" {
  description = "If true, triggers a build on PR creation or on push to a branch with an open PR."
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "A list of environment variables for the build project."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "PLAINTEXT")
  }))
}

# --- SSM ---
variable "ssm_latest_tag_parameter_name" {
  description = "If set (e.g., '/app/latest_tag'), creates an SSM Parameter to store the latest image tag. This value will also be injected into the build as the SSM_PARAMETER_NAME environment variable."
  type        = string
  default     = ""
}

###spacelift
variable "spacelift_api_secret_arn" {
  description = "The ARN of the Spacelift API key (stored in Secrets Manager) to inject into the build."
  type        = string
  default     = ""
}

variable "spacelift_ecs_stack_id" {
  description = "The Spacelift ID of the ECS deployment stack that CodeBuild should trigger after a successful build."
  type        = string
  default     = ""
}