terraform {
  backend "s3" {
    bucket         = "drazex-terraform-statefiles"
    key            = "dev/alb/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

# Add remote state reference for VPC
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "drazex-terraform-statefiles"
    key    = "dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "alb" {
  source = "../../../modules/alb"

  vpc_id                         = data.terraform_remote_state.vpc.outputs.drazex_vpc_id
  public_subnet_ids             = [
    data.terraform_remote_state.vpc.outputs.drazex_public_subnet_one,
    data.terraform_remote_state.vpc.outputs.drazex_public_subnet_two
  ]
  target_group_port             = var.target_group_port
  target_group_health_check_path = var.target_group_health_check_path
  target_group_health_check_codes = var.target_group_health_check_codes
  environment                    = "dev"
}

output "drazex_load_balancer_arn" {
  value = module.alb.load_balancer_arn
}

output "drazex_target_group_arn" {
  value = module.alb.target_group_arn
}

output "drazex_load_balancer_security_group_id" {
  value = module.alb.load_balancer_security_group_id
}

output "drazex_load_balancer_dns_name" {
  value = module.alb.load_balancer_dns_name
}