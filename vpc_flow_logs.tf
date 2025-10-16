resource "aws_iam_role" "vpc_flow_log_role" {
  name = "${var.username}-${var.repo}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "${var.username}-${var.repo}-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "${var.username}-${var.repo}-vpc-flow-logs"
  retention_in_days = 7
}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn         = aws_iam_role.vpc_flow_log_role.arn
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
}
