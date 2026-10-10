variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version of the control plane"
  type        = string
}

variable "vpc_id" {
  description = "VPC to deploy the cluster into"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets for the control plane and worker nodes"
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 instance types for the managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "tags" {
  description = "Extra tags for all EKS resources"
  type        = map(string)
  default     = {}
}

variable "enable_irsa" {
  description = "Create an OIDC provider so pods can use IAM Roles for Service Accounts"
  type        = bool
  default     = true
}
