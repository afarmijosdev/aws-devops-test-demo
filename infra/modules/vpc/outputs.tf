output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "subnet_ids_by_cidr" {
  description = "Map of subnet CIDR => subnet ID, for every subnet in the VPC"
  value = merge(
    zipmap(local.subnets_by_type.public[*].cidr, module.vpc.public_subnets),
    zipmap(local.subnets_by_type.private[*].cidr, module.vpc.private_subnets),
    zipmap(local.subnets_by_type.database[*].cidr, module.vpc.database_subnets),
  )
}

output "database_subnet_ids" {
  value = module.vpc.database_subnets
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}
