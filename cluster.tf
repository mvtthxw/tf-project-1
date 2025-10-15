resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_template" "ecs_instance" {
  name          = "${var.cluster_name}-lt"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data = base64encode(<<-EOF
        #!/bin/bash
        yum install -y aws-cli
        echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
    EOF
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-instance"
    }
  }

}

resource "aws_autoscaling_group" "ecs_instance" {
  name                = "${var.cluster_name}-instance"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_capacity
  max_size            = var.max_capacity
  vpc_zone_identifier = aws_subnet.private[*].id
  launch_template {
    id      = aws_launch_template.ecs_instance.id
    version = "$Latest"
  }
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-instance"
    propagate_at_launch = true
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.cluster_name}-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.cluster_name}-ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr}"]
    #security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-ecs-instance-sg"
  }
}