resource "aws_security_group" "ec2_security_group_ssh" {
  name        = "ssh-${var.app_name}-ec2"
  description = "security group on ec2 of ${var.app_name} for ssh"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg of ec2 for ssh"
  }
}

resource "aws_security_group" "ephemeral_port1" {
  name        = "Ephemeral-port1-${var.app_name}-ec2"
  description = "Ephemeral port 1 ec2 of ${var.app_name}"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 49153
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ephemeral port of ec2"
  }
}

resource "aws_security_group" "ephemeral_port2" {
  name        = "Ephemeral-port2-${var.app_name}-ec2"
  description = "Ephemeral port 2 ec2 of ${var.app_name}"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    from_port   = 32768
    to_port     = 61000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ephemeral port of ec2"
  }
}
