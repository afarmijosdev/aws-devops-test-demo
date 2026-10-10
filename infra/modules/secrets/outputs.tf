output "aws_secret_arns" {
  value = { for name, s in aws_secretsmanager_secret.this : name => s.arn }
}

output "credentials" {
  description = "Generated {username, password} per secret name"
  value       = local.credentials
  sensitive   = true
}

output "kubernetes_secret_names" {
  value = { for name, s in kubernetes_secret_v1.this : name => s.metadata[0].name }
}
