variable "name" {
  description = "Name of the service (Helm release, Deployment and Service)"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into (created if missing)"
  type        = string
}

variable "image" {
  description = "Container image repository, without the tag"
  type        = string
}

variable "tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "replicas" {
  type    = number
  default = 1
}

variable "public" {
  description = "Expose through an internet-facing AWS load balancer; otherwise cluster-internal only"
  type        = bool
  default     = false
}

variable "env" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "secret_env" {
  description = "Environment variables read from Kubernetes secrets: NAME => { secret, key }"
  type = map(object({
    secret = string
    key    = string
  }))
  default = {}
}
