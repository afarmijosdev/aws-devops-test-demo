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

variable "subnets" {
  description = <<-EOT
    Subnets in the VPC. Order matters: within each type, the Nth subnet goes in
    azs[N % length(azs)]. Append new subnets at the end so existing ones keep
    their position and are not recreated.
  EOT
  type = list(object({
    cidr = string
    type = string                 # "public", "private" or "database"
    name = optional(string, null) # Name tag prefix; the AZ is appended
  }))

  validation {
    condition     = alltrue([for s in var.subnets : contains(["public", "private", "database"], s.type)])
    error_message = "Each subnet type must be \"public\", \"private\" or \"database\"."
  }
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
