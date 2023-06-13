module "ecs_instance_role" {
  source     = "../iam_role"
  name       = "ecs-instance-role"
  policy     = data.aws_iam_policy_document.ec2_container_service.json
  identifier = "ec2.amazonaws.com"
}

resource "aws_iam_instance_profile" "ec2_container_service" {
  name = "es2-container-service"
  role = module.ecs_instance_role.iam_role_name
}

resource "aws_iam_policy" "ssm_instance_policy" {
  name   = "ssm-instance"
  policy = data.aws_iam_policy_document.ssm_managed_instance_core.json
}

resource "aws_iam_policy_attachment" "ssm_instance_policy" {
  name       = "attach-ssm-instance"
  policy_arn = aws_iam_policy.ssm_instance_policy.arn
  roles      = [module.ecs_instance_role.iam_role_name]
}

module "auto_scaling_service_role" {
  source     = "../iam_role"
  name       = "auto-scaling-service-role"
  policy     = data.aws_iam_policy_document.auto_scaling_service.json
  identifier = "autoscaling.amazonaws.com"
}

resource "aws_launch_configuration" "this" {
  name_prefix   = "${var.app_name}-launch-configuration_"
  image_id      = data.aws_ssm_parameter.ecs_ami_id.value
  instance_type = "t3.micro"

  security_groups = [
    data.terraform_remote_state.alb.outputs.alb_security_group,
    aws_security_group.ec2_security_group_ssh.id,
    aws_security_group.ephemeral_port1.id,
    aws_security_group.ephemeral_port2.id
  ]
  enable_monitoring    = true
  ebs_optimized        = false
  iam_instance_profile = aws_iam_instance_profile.ec2_container_service.name
  key_name             = aws_key_pair.this.id

  user_data = <<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${var.app_name}-cluster >> /etc/ecs/ecs.config
  EOF

  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    delete_on_termination = false
    encrypted             = false
    volume_size           = 30
    volume_type           = "gp2"
  }
}

resource "aws_autoscaling_group" "this" {
  name = "${var.app_name}-asg"

  min_size              = 0
  max_size              = 1
  desired_capacity      = 1
  capacity_rebalance    = false
  health_check_type     = "ELB"
  launch_configuration  = aws_launch_configuration.this.name
  protect_from_scale_in = false
  vpc_zone_identifier   = data.terraform_remote_state.network.outputs.public_subnet_ids
}
