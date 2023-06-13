resource "aws_lb_target_group" "target_group" {
  name = "${var.app_name}-tg"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port     = 80
  protocol = "HTTP"

  # コンテナへの死活監視設定
  health_check {
    path = "/health"
  }
}

resource "aws_lb_listener_rule" "https_rule" {
  listener_arn = data.terraform_remote_state.alb.outputs.https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

module "ecs_service_role" {
  source     = "../iam_role"
  name       = "ecs-service-role"
  policy     = data.aws_iam_policy_document.ecs_service.json
  identifier = "ecs.amazonaws.com"
}

resource "aws_ecs_service" "ecs_service" {
  name                              = "${var.app_name}-service"
  desired_count                     = "1"
  cluster                           = aws_ecs_cluster.this.name
  health_check_grace_period_seconds = 60
  task_definition                   = aws_ecs_task_definition.task_definition.arn
  enable_execute_command            = true
  enable_ecs_managed_tags           = true
  launch_type                       = "EC2"

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}_api"
    container_port   = 3000
  }
}
