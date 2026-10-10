variable "secrets" {
  description = "Database credentials to create, keyed by secret name"
  type = map(object({
    username        = optional(string) # Defaults to the secret name
    password_length = optional(number, 32)
  }))
}

variable "namespace" {
  description = "Kubernetes namespace to copy the secrets into"
  type        = string
}

variable "recovery_window_in_days" {
  description = "Days AWS keeps a deleted secret before purging it (0 = delete immediately)"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Extra tags for the AWS secrets"
  type        = map(string)
  default     = {}
}
