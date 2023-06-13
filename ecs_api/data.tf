data "aws_caller_identity" "user" {}

data "template_file" "container_definitions" {
  template = file("container_definitions.json")

  vars = {
    app_name              = var.app_name
    account_id            = local.account_id
    rds_host              = data.terraform_remote_state.rds.outputs.db_address
    rds_username          = var.rds_username
    rds_password          = var.rds_password
    rds_db_name           = var.rds_db_name
    s3_image_bucket       = data.terraform_remote_state.s3_images.outputs.bucket_name
    s3_asset_host         = "https://${data.terraform_remote_state.s3_images.outputs.s3_endpoint}"
    aws_access_key_id     = var.s3_user_aws_access_key_id
    aws_secret_access_key = var.s3_user_aws_secret_access_key
    front_url             = "https://${var.domain}"
    token_key             = var.token_key
  }
}

# AmazonECSTaskExecutionRolePolicy の参照
data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#「AmazonECSTaskExecutionRolePolicy」ロールを継承したポリシードキュメントの定義
data "aws_iam_policy_document" "ecs_task_execution" {
  source_json = data.aws_iam_policy.ecs_task_execution_role_policy.policy

  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }
}

data "template_file" "ssm_policy" {
  template = file("ssm_policy.json")
}

data "aws_iam_policy" "ec2_container_service" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "ec2_container_service" {
  source_json = data.aws_iam_policy.ec2_container_service.policy
}

data "aws_iam_policy" "auto_scaling_service" {
  arn = "arn:aws:iam::aws:policy/aws-service-role/AutoScalingServiceRolePolicy"
}

data "aws_iam_policy_document" "auto_scaling_service" {
  source_json = data.aws_iam_policy.auto_scaling_service.policy
}

data "aws_iam_policy" "ecs_service" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs_service" {
  source_json = data.aws_iam_policy.ecs_service.policy
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ssm_managed_instance_core" {
  source_json = data.aws_iam_policy.ssm_managed_instance_core.policy
}
