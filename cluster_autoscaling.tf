#Cloudwatch metrics 
resource "aws_cloudwatch_metric_alarm" "ecs_memory_reservation_high" {
  alarm_name                = "${var.cluster_name}-memory-reservation-high"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "50"
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_out_memory_policy.arn]
  ok_actions                = []
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_reservation_low" {
  alarm_name                = "${var.cluster_name}-memory-reservation-low"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "30"
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  alarm_actions             = [aws_autoscaling_policy.scale_in_memory_policy.arn]
  ok_actions                = []
}
#Simple scaling
resource "aws_autoscaling_policy" "scale_out_memory_policy" {
  name                   = "${var.cluster_name}-scale-out-memory"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_instance.name
}

resource "aws_autoscaling_policy" "scale_in_memory_policy" {
  name                   = "${var.cluster_name}-scale-in-memory"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_instance.name
}

#Scheduled scaling
resource "aws_autoscaling_schedule" "scale_out" {
  scheduled_action_name  = "${var.cluster_name}-scheduled-scale-out"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 2
  recurrence             = "0 12 * * *"
  autoscaling_group_name = aws_autoscaling_group.ecs_instance.name
}

resource "aws_autoscaling_schedule" "scale_in" {
  scheduled_action_name  = "${var.cluster_name}-scheduled-scale-in"
  min_size               = 1
  max_size               = 3
  desired_capacity       = 1
  recurrence             = "15 12 * * *"
  autoscaling_group_name = aws_autoscaling_group.ecs_instance.name
}
/*
#Step scaling 
resource "aws_autoscaling_policy" "scale_out_memory_policy" {
  name                   = "${var.cluster_name}-scale-out-memory"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  metric_aggregation_type = "Average"
  autoscaling_group_name = aws_autoscaling_group.ecs_instance.name

  step_adjustment {
    scaling_adjustment = 1
    metric_interval_lower_bound = "0"
    metric_interval_upper_bound = "30"
  }

  step_adjustment {
    scaling_adjustment = 2
    metric_interval_lower_bound = "30"
  }
}

resource "aws_autoscaling_policy" "scale_in_memory_policy" {
  name                   = "${var.cluster_name}-scale-in-memory"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  metric_aggregation_type = "Average"
  autoscaling_group_name = aws_autoscaling_group.ecs_instance.name

  step_adjustment {
    scaling_adjustment = -1
    metric_interval_lower_bound = "10"
    metric_interval_upper_bound = "30"
  }

  step_adjustment {
    scaling_adjustment = -2
    metric_interval_lower_bound = "30"
  }
}
*/