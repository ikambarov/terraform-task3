resource "aws_lb" "task_alb" {
  name               = "task-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  tags = merge(
    var.common_tags,
    {
      Name = "Task-ALB"
    }
  )
}

resource "aws_lb_target_group" "task_tg" {
  name     = "task-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.task_vpc.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "200"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "TaskTG"
    }
  )
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.task_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task_tg.arn
  }
}