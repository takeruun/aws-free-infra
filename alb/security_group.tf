resource "aws_security_group" "this" {
  name   = "${var.app_name}-sg"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports

    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg"
  }
}
