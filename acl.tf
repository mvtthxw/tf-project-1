resource "aws_network_acl" "public_acl" {
  vpc_id = aws_vpc.main.id

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action = "deny"
    cidr_block = "100.1.1.1/32"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 200
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action = "deny"
    cidr_block = "8.8.8.8/32"
    from_port  = 0
    to_port    = 0
  }

   egress {
    rule_no    = 200
    protocol   = "-1"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  subnet_ids = [for subnet in aws_subnet.public : subnet.id]
  
  tags = {
    Name = "${var.username}-${var.repo}-public-acl"
  }
}
