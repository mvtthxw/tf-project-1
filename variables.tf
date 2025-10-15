# General
variable "username" {
  type        = string
  description = "The username of the person deploying the infrastructure"
}
variable "repo" {
  type        = string
  description = "The repository name where the Terraform code is stored"
}
variable "region" {
  type        = string
  description = "The AWS region to deploy resources in"
}

# VPC
variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}
variable "az_count" {
  type        = number
  description = "The number of Availability Zones to use"
}

# variable "instance_type" {}
# variable "key_name" {}
# variable "desired_capacity" {}
# variable "min_capacity" {}
# variable "max_capacity" {}

# variable "alb_listener_port" {}

# variable "container_image" {}
# variable "task_execution_role_name" {}
# variable "app_desired_capacity" {}
# variable "app_min_capacity" {}
# variable "app_max_capacity" {}
