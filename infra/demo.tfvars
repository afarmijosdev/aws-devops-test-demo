environment = "demo"
region      = "us-east-2"

vpc = {
  name = "demo-vpc"
  cidr = "10.0.0.0/16"

  # Availability Zones
  azs = ["us-east-2a", "us-east-2b", "us-east-2c"]

  # Within each type, subnets are spread across azs in order (1st -> 2a, 2nd -> 2b, ...).
  # Add new subnets at the END of the list so existing ones are not recreated.
  subnets = [
    { cidr = "10.0.101.0/24", type = "public" },
    { cidr = "10.0.102.0/24", type = "public" },
    { cidr = "10.0.103.0/24", type = "public" },
    { cidr = "10.0.1.0/24", type = "private" },
    { cidr = "10.0.2.0/24", type = "private" },
    { cidr = "10.0.3.0/24", type = "private" },
    { cidr = "10.0.201.0/24", type = "database", name = "db_private" },
    { cidr = "10.0.202.0/24", type = "database", name = "db_private" },
    { cidr = "10.0.203.0/24", type = "database", name = "db_private" },
  ]
}

eks = {
  cluster_name        = "demo-eks"
  kubernetes_version  = "1.34"
  node_instance_types = ["m7i-flex.large"]
  enable_irsa         = false

  # Control plane and worker nodes go in the vpc.subnets with this type (or name).
  subnets = "private"
}

# Application services (Helm releases on demo-eks)
namespace = "bookstore"

services = {
  # Backend: private, reachable only inside the cluster.
  be-inventory = {
    image    = "753654068792.dkr.ecr.us-east-2.amazonaws.com/be-inventory"
    tag      = "latest"
    port     = 8000
    replicas = 2
    public   = false
  }

  # Frontend: public through an AWS load balancer.
  fe-inventory = {
    image    = "753654068792.dkr.ecr.us-east-2.amazonaws.com/fe-inventory"
    tag      = "latest"
    port     = 8000
    replicas = 2
    public   = true
    env = {
      BACKEND_API_URL = "http://be-inventory:8000"
    }
  }
}

# RDS: SQL Server Express, single instance in the db_private subnets.
# Express doesn't run on Graviton, so db.t4g.* isn't available; db.t3.micro is the equivalent.
rds = {
  identifier     = "demo-sqlserver"
  instance_class = "db.t3.micro"
  subnets        = "db_private"
  master_secret  = "db_sa" # master login = the db_sa secret
}

# Secrets: created in AWS Secrets Manager and copied into EKS (namespace above).
# Each holds {"username", "password"}; the password is generated.
secrets = {
  db_sa  = {}
  db_api = {}
}

# ECR repositories managed by Terraform.
ecr_repositories = [
  "db-migrations", "fe-inventory", "be-inventory",
]
