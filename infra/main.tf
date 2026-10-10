locals {
  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "vpc" {
  source = "./modules/vpc"

  name = var.vpc.name
  cidr = var.vpc.cidr
  azs  = var.vpc.azs

  public_subnets  = var.vpc.public_subnets
  private_subnets = var.vpc.private_subnets

  tags = local.tags
}

module "eks" {
  source = "./modules/eks"

  name               = var.eks.cluster_name
  kubernetes_version = var.eks.kubernetes_version

  node_instance_types = var.eks.node_instance_types
  enable_irsa         = var.eks.enable_irsa

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  tags = local.tags
}

module "services" {
  source   = "./modules/k8s-service"
  for_each = var.services

  name      = each.key
  namespace = var.namespace
  image     = each.value.image
  tag       = each.value.tag
  port      = each.value.port
  replicas  = each.value.replicas
  public    = each.value.public
  env       = each.value.env

  depends_on = [module.eks]
}
