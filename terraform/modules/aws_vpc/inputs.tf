variable "aws_region" {
  description = "The AWS Region in which to deploy your resources"
}

variable "default_tags" {
  description = "A set of default Tags to apply to all taggable AWS resources"
  type = map
}

variable "tf_host_ip" {
  description = "IPv4 address of the Terraform deployment host. Used in the AWS Security Group rules"
}
