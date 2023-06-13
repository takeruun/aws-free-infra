# ECSタスク実行ロールの作成
module "ecs_task_execution_role" {
  source     = "../iam_role"
  name       = "ecs-task-execution-${var.app_name}"
  identifier = "ecs-tasks.amazonaws.com"
  policy     = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_iam_policy" "ssm_policy" {
  name   = "ssm-policy-${var.app_name}"
  policy = data.template_file.ssm_policy.rendered
}

resource "aws_iam_policy_attachment" "ssm_policy_attach" {
  name       = "attach-ssm-policy-${var.app_name}"
  policy_arn = aws_iam_policy.ssm_policy.arn
  roles      = [module.ecs_task_execution_role.iam_role_name]
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.app_name}-task"

  cpu                      = 256
  memory                   = 460
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = data.template_file.container_definitions.rendered
  task_role_arn         = module.ecs_task_execution_role.iam_role_arn
  execution_role_arn    = module.ecs_task_execution_role.iam_role_arn

  volume {
    name = "socket_data"
  }
}
