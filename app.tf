
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.cluster_name}-td"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "256"
  execution_role_arn       = data.aws_iam_role.task_role.arn

  container_definitions = jsonencode([{
    "name" : "${var.cluster_name}-app",
    "image" : "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.container_image}",
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 80,
        "hostPort" : 0,
        "protocol" : "tcp"
      }
    ]
  }])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.cluster_name}-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = var.app_desired_capacity
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "${var.cluster_name}-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.alb_listener]
}
