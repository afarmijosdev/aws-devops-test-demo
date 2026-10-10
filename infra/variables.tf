variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. demo, dev, prod)"
  type        = string
}

variable "vpc" {
  description = "VPC settings"
  type = object({
    name            = string       # Name of the VPC
    cidr            = string       # CIDR block for the VPC
    azs             = list(string) # Availability Zones for the subnets
    public_subnets  = list(string) # Public subnet CIDRs, one per AZ
    private_subnets = list(string) # Private subnet CIDRs, one per AZ
  })
}

variable "eks" {
  description = "EKS cluster settings"
  type = object({
    cluster_name        = string       # Name of the EKS cluster
    kubernetes_version  = string       # Kubernetes version of the control plane
    node_instance_types = list(string) # EC2 instance types for the managed node group
    enable_irsa         = bool         # Create OIDC provider for IAM Roles for Service Accounts
  })
}

variable "namespace" {
  description = "Kubernetes namespace for the application services"
  type        = string
}

variable "services" {
  description = "Application services to deploy on EKS, keyed by name"
  type = map(object({
    image    = string                     # ECR repository, without the tag
    tag      = optional(string, "latest") # Image tag
    port     = optional(number, 8000)     # Port the container listens on
    replicas = optional(number, 1)
    public   = optional(bool, false)     # true = internet-facing load balancer
    env      = optional(map(string), {}) # Container environment variables
  }))
}
