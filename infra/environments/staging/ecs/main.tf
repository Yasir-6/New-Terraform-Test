terraform {
  backend "s3" {
    bucket         = "drazex-staging-terraform-statefiles"
    key            = "staging/ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# Add remote state references
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "drazex-staging-terraform-statefiles"
    key    = "staging/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "drazex-staging-terraform-statefiles"
    key    = "staging/alb/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "drazex-staging-terraform-statefiles"
    key    = "staging/ecr/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ecs" {
  source = "../../../modules/ecs"

  environment            = "staging"
  container_image        = var.container_image
  container_port         = var.container_port
  env_variable_names     = var.env_variable_names
  cpu                    = var.cpu
  memory                 = var.memory
  desired_count          = var.desired_count
  use_private_subnets    = var.use_private_subnets
  enable_auto_scaling    = var.enable_auto_scaling
  env_file_arn       = var.env_file_arn
  vpc_id                 = data.terraform_remote_state.vpc.outputs.drazex_staging_vpc_id
  private_subnet_ids     = [
    data.terraform_remote_state.vpc.outputs.drazex_staging_private_subnet_one,
    data.terraform_remote_state.vpc.outputs.drazex_staging_private_subnet_two
  ]
  public_subnet_ids      = [
    data.terraform_remote_state.vpc.outputs.drazex_staging_public_subnet_one,
    data.terraform_remote_state.vpc.outputs.drazex_staging_public_subnet_two
  ]
  alb_security_group_id  = data.terraform_remote_state.alb.outputs.drazex_staging_load_balancer_security_group_id
  alb_target_group_arn   = data.terraform_remote_state.alb.outputs.drazex_staging_target_group_arn
}

# Outputs
output "drazex_staging_ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "drazex_staging_ecs_service_name" {
  value = module.ecs.service_name
}

output "drazex_staging_ecs_task_definition_arn" {
  value = module.ecs.task_definition_arn
}

output "drazex_staging_ecs_task_execution_role_arn" {
  value = module.ecs.task_execution_role_arn
}

output "drazex_staging_ecs_task_role_arn" {
  value = module.ecs.task_role_arn
}

output "drazex_staging_ecs_task_security_group_id" {
  value = module.ecs.task_security_group_id
}