
resource "aws_appautoscaling_target" "ecs_service_target" {
  max_capacity       = var.app_max_capacity
  min_capacity       = var.app_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_cloudwatch_metric_alarm" "high_request_count" {
  alarm_name          = "${var.cluster_name}-app-HighRequestCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 30
  dimensions = {
    TargetGroup  = aws_lb_target_group.alb_tg.arn_suffix
    LoadBalancer = aws_lb.alb.arn_suffix
  }

  alarm_actions = [
    aws_appautoscaling_policy.scale_up_policy.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "low_request_count" {
  alarm_name          = "${var.cluster_name}-app-LowRequestCount"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 25
  dimensions = {
    TargetGroup  = aws_lb_target_group.alb_tg.arn_suffix
    LoadBalancer = aws_lb.alb.arn_suffix
  }

  alarm_actions = [
    aws_appautoscaling_policy.scale_down_policy.arn
  ]
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  name               = "${var.cluster_name}-app-scale-up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  name               = "${var.cluster_name}-app-scale-down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}
