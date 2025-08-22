
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}

variable "scan_on_push" {
  description = "Indicates whether images should be scanned after being pushed to the repository"
  type        = bool
  default     = true
}
