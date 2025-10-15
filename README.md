# ECS Cluster

This project provisions a scalable AWS infrastructure using Terraform (without modules). It demonstrates a production-like setup with VPC, ECS cluster, EC2 autoscaling, and a dual load balancer architecture (NLB + ALB).

## Architecture Overview

- **VPC**: Custom Virtual Private Cloud with public and private subnets across multiple Availability Zones. Includes Internet Gateway, NAT Gateway, and proper route tables for public/private networking.

- **ECS Cluster**: Amazon ECS cluster running on EC2 instances. EC2 instances are managed by an Auto Scaling Group for high availability and scalability.

- **EC2 Autoscaling**: The cluster's EC2 instances are automatically scaled based on CloudWatch metrics (memory reservation, scheduled scaling, etc.).

- **Application Service**: ECS Service runs a containerized application, with its own autoscaling policies based on ALB request count.

- **Load Balancers**:
	- **NLB (Network Load Balancer)**: Exposes the application to the public internet. Listens on public subnets and forwards traffic to the internal ALB.
	- **ALB (Application Load Balancer)**: Deployed in private subnets. Handles HTTP traffic and routes requests to ECS tasks. Only accessible via the NLB by default.
	- **Alternative**: You can use `alb_public.tfdisabled` to deploy the ALB directly in public subnets, making it public-facing without the NLB.

## Key Components

- `vpc.tf`: VPC, subnets, route tables, NAT gateway
- `cluster.tf`: ECS cluster, EC2 launch template, ASG, IAM roles
- `app.tf`: ECS task definition and service
- `alb.tf`: Application Load Balancer (private by default)
- `nlb.tf`: Network Load Balancer (public)
- `app_autoscaling.tf`: ECS service autoscaling (based on ALB metrics)
- `cluster_autoscaling.tf`: EC2 autoscaling (based on memory and schedule)
- `alb_public.tfdisabled`: (Optional) ALB in public subnets, no NLB
- `variables.tf`, `outputs.tf`, `versions.tf`, `data.tf`: Supporting files

## How Traffic Flows
1. **NLB** (public) receives external traffic on port 80.
2. NLB forwards traffic to the **ALB** (private).
3. ALB routes HTTP requests to ECS tasks running in private subnets.
4. Security groups ensure only the NLB can access the ALB.

## Usage
1. Configure variables in `terraform.tfvars` as needed.
2. Initialize and apply Terraform:
	 ```sh
	 terraform init
	 terraform apply
	 ```
3. To use only the ALB in public subnets, rename `alb_public.tfdisabled` and remove/disable the ALB and NLB resources.

## Scaling
- **EC2 Cluster**: Scales based on memory reservation and scheduled actions.
- **ECS Service**: Scales based on ALB request count (step scaling policies).
