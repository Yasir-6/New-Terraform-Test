terraform {
  backend "s3" {
    bucket         = "drazex-terraform-statefiles"
    key            = "dev/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr = "10.2.0.0/16"
  
  public_subnet_cidrs = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24"
  ]
  
  private_subnet_cidrs = [
    "10.2.100.0/24",
    "10.2.101.0/24",
    "10.2.102.0/24"
  ]
  
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}

output "drazex_vpc_id" {
  value = module.vpc.vpc_id
}

output "drazex_public_subnet_one" {
  value = module.vpc.public_subnet_ids[0]
}

output "drazex_public_subnet_two" {
  value = module.vpc.public_subnet_ids[1]
}

output "drazex_public_subnet_three" {
  value = module.vpc.public_subnet_ids[2]
}

output "drazex_private_subnet_one" {
  value = module.vpc.private_subnet_ids[0]
}

output "drazex_private_subnet_two" {
  value = module.vpc.private_subnet_ids[1]
}

output "drazex_private_subnet_three" {
  value = module.vpc.private_subnet_ids[2]
}
