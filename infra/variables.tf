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
    name = string       # Name of the VPC
    cidr = string       # CIDR block for the VPC
    azs  = list(string) # Availability Zones for the subnets
    subnets = list(object({
      cidr = string
      type = string                 # "public", "private" or "database"
      name = optional(string, null) # Name tag prefix; the AZ is appended
    }))
  })
}

variable "eks" {
  description = "EKS cluster settings"
  type = object({
    cluster_name        = string       # Name of the EKS cluster
    kubernetes_version  = string       # Kubernetes version of the control plane
    node_instance_types = list(string) # EC2 instance types for the managed node group
    enable_irsa         = bool         # Create OIDC provider for IAM Roles for Service Accounts
    subnets             = string       # Type or name of the vpc.subnets to use (e.g. "private")
    # IAM ARNs (e.g. the GitHub Actions user) allowed to edit the app namespace.
    deployer_arns = optional(list(string), [])
  })

  validation {
    condition = length([
      for s in var.vpc.subnets : s if s.type == var.eks.subnets || s.name == var.eks.subnets
    ]) >= 2
    error_message = "eks.subnets must match the type or name of at least two vpc.subnets (EKS needs two AZs)."
  }
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
    # Container environment variables read from Kubernetes secrets: NAME => { secret, key }
    secret_env = optional(map(object({
      secret = string
      key    = string
    })), {})
  }))
}

variable "rds" {
  description = "RDS SQL Server Express settings"
  type = object({
    identifier        = string               # RDS instance identifier
    instance_class    = string               # db.t3.micro - db.t3.xlarge
    engine_version    = optional(string)     # null = RDS default
    allocated_storage = optional(number, 20) # GiB
    subnets           = string               # Type or name of the vpc.subnets to use
    master_secret     = string               # Key in var.secrets holding the master login
  })

  validation {
    condition = length([
      for s in var.vpc.subnets : s if s.type == var.rds.subnets || s.name == var.rds.subnets
    ]) >= 2
    error_message = "rds.subnets must match the type or name of at least two vpc.subnets (RDS needs two AZs)."
  }

  validation {
    condition     = contains(keys(var.secrets), var.rds.master_secret)
    error_message = "rds.master_secret must be one of the keys in secrets."
  }
}

variable "secrets" {
  description = "Database credentials stored in AWS Secrets Manager and copied into EKS, keyed by secret name"
  type = map(object({
    username        = optional(string) # Defaults to the secret name
    password_length = optional(number, 32)
  }))
  default = {}
}

variable "ecr_repositories" {
  description = "Names of the ECR repositories to create"
  type        = list(string)
  default     = []
}
