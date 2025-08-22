
resource "aws_ecr_repository" "drazex_staging_ecr_repo" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = {
    Name        = var.repository_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
