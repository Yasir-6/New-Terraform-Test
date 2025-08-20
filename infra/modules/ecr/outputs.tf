
output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.drazex_ecr_repo.repository_url
}

output "repository_arn" {
  description = "The ARN of the repository"
  value       = aws_ecr_repository.drazex_ecr_repo.arn
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.drazex_ecr_repo.registry_id
}
