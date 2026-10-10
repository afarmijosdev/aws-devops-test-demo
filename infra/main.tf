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

  subnets = var.vpc.subnets

  tags = local.tags
}

module "eks" {
  source = "./modules/eks"

  name               = var.eks.cluster_name
  kubernetes_version = var.eks.kubernetes_version

  node_instance_types = var.eks.node_instance_types
  enable_irsa         = var.eks.enable_irsa

  deployer_arns       = var.eks.deployer_arns
  deployer_namespaces = [var.namespace]

  vpc_id = module.vpc.vpc_id
  # Every vpc.subnets entry whose type or name matches eks.subnets.
  subnet_ids = [
    for s in var.vpc.subnets : module.vpc.subnet_ids_by_cidr[s.cidr]
    if s.type == var.eks.subnets || s.name == var.eks.subnets
  ]

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

module "secrets" {
  source = "./modules/secrets"

  secrets   = var.secrets
  namespace = var.namespace
  tags      = local.tags

  # The namespace is created by the service Helm releases.
  depends_on = [module.services]
}

module "rds" {
  source = "./modules/rds-sqlserver"

  identifier        = var.rds.identifier
  instance_class    = var.rds.instance_class
  engine_version    = var.rds.engine_version
  allocated_storage = var.rds.allocated_storage

  vpc_id = module.vpc.vpc_id
  # Every vpc.subnets entry whose type or name matches rds.subnets.
  subnet_ids = [
    for s in var.vpc.subnets : module.vpc.subnet_ids_by_cidr[s.cidr]
    if s.type == var.rds.subnets || s.name == var.rds.subnets
  ]
  # Pods on the EKS nodes can reach SQL Server.
  allowed_security_group_ids = [module.eks.node_security_group_id]

  master_username = module.secrets.credentials[var.rds.master_secret].username
  master_password = module.secrets.credentials[var.rds.master_secret].password

  tags = local.tags
}

module "ecr" {
  source = "./modules/ecr"

  repositories = var.ecr_repositories
  tags         = local.tags
}
