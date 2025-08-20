
terraform {
  backend "s3" {
    bucket         = "drazex-terraform-statefiles"
    key            = "dev/ecr/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ecr" {
  source = "../../../modules/ecr"

  repository_name      = "drazex_ecr_repo"
  image_tag_mutability = "MUTABLE"
  environment         = "dev"
  scan_on_push        = true
}

# Outputs
output "drazex_ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "drazex_ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "drazex_ecr_registry_id" {
  description = "The registry ID"
  value       = module.ecr.registry_id
}
