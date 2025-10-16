# ECS Cluster

This project provisions a scalable AWS infrastructure using Terraform (without modules). It demonstrates a production-like setup with VPC, ECS cluster, EC2 autoscaling, and a dual load balancer architecture (NLB + ALB).

## Architecture Overview

- **VPC**: Custom Virtual Private Cloud with public and private subnets across multiple Availability Zones. Includes Internet Gateway, NAT Gateway, and proper route tables for public/private networking.
- **Security**:
	- **Network ACLs**: Public subnets are protected by network ACLs (see `acl.tf`) that allow or deny specific traffic at the subnet level. Example: Deny HTTP from a specific IP, allow all other traffic.
	- **Security Groups**: Used to restrict access between load balancers, ECS instances, and the internet. Only the NLB can access the ALB by default.
	- **WAF (Web Application Firewall)**: AWS WAF is attached to the NLB to protect against common web exploits, block specific IPs, and rate-limit requests. Includes managed rule sets and custom rules (see `waf.tf`).
	- **VPC Flow Logs**: Monitors and logs all network traffic in the VPC for security auditing and troubleshooting (see `vpc_flow_logs.tf`).

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
- `acl.tf`: Network ACLs for public subnets, with custom rules for ingress/egress
- `waf.tf`: AWS WAF configuration, rules, and association with the NLB
- `vpc_flow_logs.tf`: VPC Flow Logs setup for monitoring network traffic
- `variables.tf`, `outputs.tf`, `versions.tf`, `data.tf`: Supporting files

## How Traffic and Security Flows
1. **NLB** (public) receives external traffic on port 80.
2. NLB forwards traffic to the **ALB** (private).
3. ALB routes HTTP requests to ECS tasks running in private subnets.
4. Security groups ensure only the NLB can access the ALB.
5. Network ACLs on public subnets provide an additional layer of security, blocking or allowing traffic at the subnet boundary (e.g., blocking specific IPs from HTTP access).

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

## Security
- **WAF (Web Application Firewall)**: Defined in `waf.tf`, the WAF is attached to the NLB and provides:
	- Managed rule sets (e.g., SQL injection protection)
	- Custom IP blocking (e.g., block specific IPs or ranges)
	- Rate limiting (e.g., block IPs exceeding request thresholds)
	- All rules are visible in CloudWatch metrics
- **VPC Flow Logs**: Defined in `vpc_flow_logs.tf`, these capture all network traffic in the VPC and send logs to CloudWatch for auditing and troubleshooting. IAM roles and log groups are provisioned automatically.
- **Network ACLs**: Defined in `acl.tf`, these provide stateless filtering of traffic at the subnet level. Example rules:
	- Deny HTTP (port 80) from a specific IP (e.g., 100.1.1.1)
	- Allow all other inbound traffic
	- Deny outbound traffic to a specific IP (e.g., 8.8.8.8)
	- Allow all other outbound traffic
- **Security Groups**: Used for stateful, instance-level access control between resources (load balancers, ECS, etc.)
