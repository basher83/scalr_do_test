locals {
  default_tags = {
    "managed-by" = "terraform"
    "project"    = "scalr-test"
    "created"    = timestamp()
  }
  
  environment_tags = {
    development = {
      "environment" = "development"
      "cost-center" = "dev-ops"
    }
    staging = {
      "environment" = "staging"
      "cost-center" = "dev-ops"
    }
    production = {
      "environment" = "production"
      "cost-center" = "production"
    }
  }
}