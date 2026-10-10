variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
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

variable "single_nat_gateway" {
  description = "Share one NAT gateway across all AZs (cheaper, not highly available)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags for all VPC resources"
  type        = map(string)
  default     = {}
}
