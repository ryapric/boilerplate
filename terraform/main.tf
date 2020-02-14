terraform {
  required_version = "~> 0.12"

  # # You can include a placeholder for backend config, and populate it
  # # dynamically with a `.tfvars` file. This is useful for when deploying
  # # identical infra to multiple environments.
  # backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  version = ">= 2.47"
}

# Call a module. You can also have these be in a separate repo entirely
module "main" {
  source = "./modules/some-module"

  # Pass variables into the module. These will also come from a `.tfvars` file,
  # passed in at runtime from the CLI
  aws_region = var.aws_region
  
  tf_host_ip = var.tf_host_ip

  default_tags = var.default_tags
}
