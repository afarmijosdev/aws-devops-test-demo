resource "random_password" "this" {
  for_each = var.secrets

  length = each.value.password_length
  # Leave out characters RDS rejects in passwords ('/', '@', '"', ' ').
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  credentials = {
    for name, s in var.secrets : name => {
      username = coalesce(s.username, name)
      password = random_password.this[name].result
    }
  }
}

# Source of truth: AWS Secrets Manager.
resource "aws_secretsmanager_secret" "this" {
  for_each = var.secrets

  name                    = each.key
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = var.secrets

  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = jsonencode(local.credentials[each.key])
}

# Copy into EKS. Kubernetes names can't contain "_", so db_sa becomes db-sa.
resource "kubernetes_secret_v1" "this" {
  for_each = var.secrets

  metadata {
    name      = replace(each.key, "_", "-")
    namespace = var.namespace
    annotations = {
      "aws-secret-arn" = aws_secretsmanager_secret.this[each.key].arn
    }
  }

  type = "Opaque"
  data = local.credentials[each.key]
}
