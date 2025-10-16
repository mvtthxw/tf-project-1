# Create a WAFv2 Web ACL
resource "aws_wafv2_web_acl" "waf" {
  name        = "${var.username}-${var.repo}-web-acl"
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.username}-${var.repo}-waf-metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "${var.username}-${var.repo}-BlockSpecificIPRange"
    priority = 1
    action {
      block {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_set.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.username}-${var.repo}-BlockSpecificIPRange"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "${var.username}-${var.repo}-BlockRateLimit"
    priority = 2
    action {
      block {}
    }
    statement {
      rate_based_statement {
        limit              = 100
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.username}-${var.repo}-BlockRateLimit"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 0

    override_action {
      count {}
    }

    statement {

      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

#IP Set
resource "aws_wafv2_ip_set" "ip_set" {
  name        = "${var.username}-${var.repo}-ip-set"
  scope       = "REGIONAL"
  description = "IP set"
  ip_address_version = "IPV4"
  addresses = ["99.1.1.1/32"]
}

#Associate WAF and LB
resource "aws_wafv2_web_acl_association" "waf-alb" {
  resource_arn = aws_lb.nlb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
}
