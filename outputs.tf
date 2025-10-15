# VPC
output "vpc" {
  value = aws_vpc.main.id
}

output "igw" {
  value = aws_internet_gateway.main.id
}

output "cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.cidr_block]
}

output "nat_gateway" {
  value = aws_nat_gateway.main.id
}

# ECS Cluster
output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_instance_security_group" {
  value = aws_security_group.ecs_sg.id
}

output "ecs_instance_role" {
  value = aws_iam_role.ecs_instance_role.name
}

output "ecs_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

output "ecs_autoscaling_group" {
  value = aws_autoscaling_group.ecs_instance.name
}
