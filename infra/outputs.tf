output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}"
}

output "fe_inventory_url_command" {
  description = "Prints the public URL of fe-inventory once its load balancer is ready"
  value       = "kubectl get svc fe-inventory -n ${var.namespace} -o jsonpath='http://{.status.loadBalancer.ingress[0].hostname}'"
}
