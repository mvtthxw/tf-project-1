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

# ALB
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_security_group" {
  value = aws_security_group.alb_sg.id
}

output "alb_listener_arn" {
  value = aws_lb_listener.alb_listener.arn
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

# NLB
output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}

output "nlb_security_group" {
  value = aws_security_group.nlb_sg.id
}

output "nlb_listener_arn" {
  value = aws_lb_listener.nlb_listener.arn
}
