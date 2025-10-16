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

# ECS Cluster
variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type for the ECS cluster"
}

variable "key_name" {
  type        = string
  description = "The name of the key pair to use for EC2 instances"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in the ECS cluster"
}

variable "min_capacity" {
  type        = number
  description = "Min number of instances in the ECS cluster"
}

variable "max_capacity" {
  type        = number
  description = "Max number of instances in the ECS cluster"
}

# LB
variable "alb_listener_port" {
  type        = number
  description = "The port for the ALB listener"
}

# App
variable "container_image" {
  type        = string
  description = "The container image to deploy in the ECS task"
}

variable "task_execution_role_name" {
  type        = string
  description = "The name of the IAM role for ECS task execution"
}

variable "app_desired_capacity" {
  type        = number
  description = "Desired number of tasks in the ECS service"
}

variable "app_min_capacity" {
  type        = number
  description = "Min number of tasks in the ECS service"
}

variable "app_max_capacity" {
  type        = number
  description = "Max number of tasks in the ECS service"
}

# Security
variable "ingress_deny_cidr" {
  type        = string
  description = "The CIDR block to deny ingress traffic from"
}

variable "egress_deny_cidr" {
  type        = string
  description = "The CIDR block to deny egress traffic to"
}

variable "waf_block_ip" {
  type        = list(string)
  description = "The IP address to block in the WAF"
}
