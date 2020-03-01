variable "aws_region" {
  description = "The AWS Region in which to deploy your resources"
}

variable "default_tags" {
  description = "A set of default Tags to apply to all taggable AWS resources"
  type = map
}

variable "tf_host_ip" {
  description = "The deployment host IP, for use in cloud firewalls (like Security Groups), etc."
  # Dummy default to prevent unintended access
  default = "127.0.0.1"
}

variable "instance_count" {
  description = "Number of identical instances to deploy"
}
