environment = "demo"
region      = "us-east-2"

vpc = {
  name = "demo-vpc"
  cidr = "10.0.0.0/16"

  # Availability Zones
  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

eks = {
  cluster_name        = "demo-eks"
  kubernetes_version  = "1.34"
  node_instance_types = ["m7i-flex.large"]
  enable_irsa         = false
}

# Application services (Helm releases on demo-eks)
namespace = "bookstore"

services = {
  # Backend: private, reachable only inside the cluster.
  be-inventory = {
    image  = "753654068792.dkr.ecr.us-east-2.amazonaws.com/be-inventory"
    tag    = "latest"
    port   = 8000
    public = false
  }

  # Frontend: public through an AWS load balancer.
  fe-inventory = {
    image  = "753654068792.dkr.ecr.us-east-2.amazonaws.com/fe-inventory"
    tag    = "latest"
    port   = 8000
    public = true
    env = {
      BACKEND_API_URL = "http://be-inventory:8000"
    }
  }
}
