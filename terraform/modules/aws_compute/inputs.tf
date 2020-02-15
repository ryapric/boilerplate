variable "aws_region" {
  description = "The AWS Region in which to deploy your resources"
}

variable "default_tags" {
  description = "A set of default Tags to apply to all taggable AWS resources"
  type = map
}

variable "pubkey_path" {
  description = "Path to your desired public key file to use when making an AWS Key Pair"
  default = "~/.ssh/id_rsa.pub"
}

variable "subnet_id" {
  description = "AWS Subnet ID to place instance into"
}

variable "security_group_ids" {
  description = "IDs of the Security Groups to attach to the instance"
  type = list
}
