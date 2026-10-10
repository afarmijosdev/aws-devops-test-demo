# Credentials come from the environment (AWS_PROFILE / AWS_ACCESS_KEY_ID etc.).
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "aws-devops-test-demo"
      ManagedBy = "terraform"
    }
  }
}

# Helm talks to the EKS cluster; charts for services go in as helm_release resources.
# Auth uses the AWS CLI with the same AWS_PROFILE as the aws provider.
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", var.region]
    }
  }
}
