variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g. demo, dev, prod)"
  type        = string
}

# VPC
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones for the subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets, one per AZ"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for the private subnets, one per AZ"
  type        = list(string)
}
