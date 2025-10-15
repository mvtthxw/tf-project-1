data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*-x86_64-ebs"]
  }
}

data "aws_iam_role" "task_role" {
  name = var.task_execution_role_name
}
