variable "repositories" {
  description = "Names of the ECR repositories to create"
  type        = list(string)
}

variable "max_image_count" {
  description = "Keep only the newest N images per repository"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Extra tags for the repositories"
  type        = map(string)
  default     = {}
}
