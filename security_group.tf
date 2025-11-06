resource "aws_security_group" "codebuild_sg" {
  name        = "${var.app_name}-sg"
  description = "Security group for CodeBuild VPC access for ${var.app_name}"
  vpc_id      = data.aws_vpc.selected.id
  tags        = var.common_tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "is-default"
    values = ["true"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}