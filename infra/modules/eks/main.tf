module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name
  kubernetes_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Public API endpoint so kubectl/helm work from your machine.
  endpoint_public_access = true

  # Give the identity running terraform cluster-admin access.
  enable_cluster_creator_admin_permissions = true

  enable_irsa = var.enable_irsa

  # Deployers (e.g. GitHub Actions) get the Kubernetes "edit" role, only in
  # their namespaces: create/delete Jobs and Deployments, read pods and logs.
  access_entries = {
    for arn in var.deployer_arns : arn => {
      principal_arn = arn
      policy_associations = {
        edit = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            type       = "namespace"
            namespaces = var.deployer_namespaces
          }
        }
      }
    }
  }

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size
    }
  }

  tags = var.tags
}
