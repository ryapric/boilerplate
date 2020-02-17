variable "aws_region" {
  description = "The AWS Region in which to deploy your resources"
}

variable "default_tags" {
  description = "A set of default Tags to apply to all taggable AWS resources"
  type = map
}

variable "subnet_id" {
  description = "AWS Subnet ID to ..."
}

variable "security_group_ids" {
  description = "IDs of the Security Groups to attach to the ..."
  type = list
}
