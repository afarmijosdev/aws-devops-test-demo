locals {
  # Name-tag suffix the upstream module uses for each subnet type.
  subnet_suffix = { public = "public", private = "private", database = "db" }

  subnets_by_type = {
    for type in keys(local.subnet_suffix) : type => [for s in var.subnets : s if s.type == type]
  }

  # Within each type the Nth subnet goes in azs[N]. Subnets without a name keep
  # the upstream default "<vpc>-<suffix>-<az>"; named ones become "<name>-<az>".
  subnet_names = {
    for type, subnets in local.subnets_by_type : type => [
      for i, s in subnets : format("%s-%s",
        coalesce(s.name, "${var.name}-${local.subnet_suffix[type]}"),
        element(var.azs, i)
      )
    ]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.name
  cidr = var.cidr
  azs  = var.azs

  public_subnets       = local.subnets_by_type.public[*].cidr
  public_subnet_names  = local.subnet_names.public
  private_subnets      = local.subnets_by_type.private[*].cidr
  private_subnet_names = local.subnet_names.private

  # Database subnets: isolated route table (no NAT/internet route), an RDS
  # subnet group, and not used by EKS.
  database_subnets                   = local.subnets_by_type.database[*].cidr
  database_subnet_names              = local.subnet_names.database
  create_database_subnet_route_table = length(local.subnets_by_type.database) > 0
  create_database_subnet_group       = false # each database module creates its own

  # Outbound internet for private subnets (needed by EKS nodes).
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags so EKS load balancers can discover the subnets.
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}
