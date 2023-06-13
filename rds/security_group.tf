resource "aws_security_group" "db_sg" {
  name        = "${var.app_name}-mysql"
  description = "security group on db of ${var.app_name}"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg of mysql"
  }
}

resource "aws_security_group_rule" "mysql-rule" {
  security_group_id = aws_security_group.db_sg.id

  type = "ingress"

  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = data.terraform_remote_state.alb.outputs.alb_security_group
}
