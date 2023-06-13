resource "aws_cloudwatch_log_group" "log" {
  count = length(var.containers_name)
  name  = "/ecs/${var.app_name}/${var.containers_name[count.index]}"

  retention_in_days = 60
}
