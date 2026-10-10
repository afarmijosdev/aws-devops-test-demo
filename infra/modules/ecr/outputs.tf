output "repository_urls" {
  description = "Map of repository name => URL to push/pull images"
  value       = { for name, r in aws_ecr_repository.this : name => r.repository_url }
}
