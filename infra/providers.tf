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
