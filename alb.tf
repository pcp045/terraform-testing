# alb.tf

resource "aws_alb" "main" {
  name            = "smrdev-load-balancer"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "app" {
  name        = "smrdev-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "10"  #The number of consecutive health checks successes required before considering an unhealthy target healthy (2-10).
    interval            = "300" #The approximate amount of time between health checks of an individual target(5-300).
    protocol            = "HTTP"
    matcher             = "200" 
    timeout             = "120" #The amount of time, in seconds, during which no response means a failed health check(2-120).
    path                = var.health_check_path
    unhealthy_threshold = "10" #The number of consecutive health check failures required before considering a target unhealthy(2-10).
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}

