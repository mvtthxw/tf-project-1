output "vpc" {
  value       = aws_vpc.main.id
}

output "igw" {
  value       = aws_internet_gateway.main.id
}

output "cidr" {
  value       = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.cidr_block]
}

output "nat_gateway" {
  value       = aws_nat_gateway.main.id
}
