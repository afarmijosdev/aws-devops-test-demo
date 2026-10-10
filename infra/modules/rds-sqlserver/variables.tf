variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "instance_class" {
  description = "Instance class. SQL Server Express runs only on db.t3.micro - db.t3.xlarge (no Graviton/t4g)"
  type        = string

  validation {
    condition     = contains(["db.t3.micro", "db.t3.small", "db.t3.medium", "db.t3.large", "db.t3.xlarge"], var.instance_class)
    error_message = "SQL Server Express supports only db.t3.micro through db.t3.xlarge."
  }
}

variable "engine_version" {
  description = "SQL Server version (e.g. 16.00); null lets RDS pick its default"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "Storage in GiB (SQL Server minimum is 20; Express maximum is 10 GB per database)"
  type        = number
  default     = 20
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets for the DB subnet group (at least two AZs)"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect on port 1433 (e.g. the EKS nodes)"
  type        = list(string)
  default     = []
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "backup_retention_period" {
  description = "Days to keep automated backups (0 disables them)"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Extra tags for all RDS resources"
  type        = map(string)
  default     = {}
}
