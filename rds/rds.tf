resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_name
  description = "db subent group of ${var.db_name}"
  subnet_ids  = data.terraform_remote_state.network.outputs.private_subnet_ids
}

resource "aws_db_instance" "db" {
  allocated_storage = 10
  storage_type      = "gp2"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.db_instance

  identifier          = var.app_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
}
