# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "smrdev_log_group" {
  name              = "/ecs/smrdev-app"
  retention_in_days = 30

  tags = {
    Name = "smrdev-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "smrdev_log_stream" {
  name           = "smrdev-log-stream"
  log_group_name = aws_cloudwatch_log_group.smrdev_log_group.name
}

