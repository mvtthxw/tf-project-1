# General
username = "mvtthxw"
repo     = "ecs-app"
region   = "eu-west-2"

# VPC
cidr     = "10.100.0.0/20"
az_count = 3

# ECS Cluster
cluster_name     = "mvtthxw-ecs-cluster"
instance_type    = "t3.micro"
key_name         = "mxtthxw-key"
desired_capacity = 1
min_capacity     = 1
max_capacity     = 3

# LB
alb_listener_port = 80

# App
task_execution_role_name = "ecsTaskExecutionRole"
container_image          = "mmedyk-k8s-ecr-app1:v2"
app_desired_capacity     = 1
app_min_capacity         = 1
app_max_capacity         = 7

# ACL
ingress_deny_cidr = "100.1.1.1/32"
egress_deny_cidr  = "8.8.8.8/32"
waf_block_ip      = ["99.1.1.1/32"]
