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

# Call modules. You can also have these be in a separate repo entirely, and
# refer to them by their URL, and even their tag/commit hash.
module "aws_vpc" {
  source = "./modules/aws_vpc"

  # Pass variables into the module. These will either come from a `.tfvars`
  # file, passed in at runtime from the CLI, or from another called module, as
  # you can see in the next caller.
  aws_region = var.aws_region
  
  tf_host_ip = var.tf_host_ip
  
  default_tags = var.default_tags
}

# Another module call, passing in the outputs from the first one.
module "aws_compute" {
  source = "./modules/aws_compute"

  instance_count = var.instance_count

  instance_nametag = "master_tf-created"

  aws_region = var.aws_region

  subnet_id          = module.aws_vpc.subnet_id
  security_group_ids = module.aws_vpc.security_group_ids

  default_tags = var.default_tags
}

# module "aws_fargate" {
#   source = "./modules/aws_fargate"
# }
