variable "aws_region" {
  description = "The AWS Region in which to deploy your resources"
}

variable "default_tags" {
  description = "A set of default Tags to apply to all taggable AWS resources"
  type = map
}

variable "tf_host_ip" {
  description = "The deployment host IP, for use in cloud firewalls (like Security Groups), etc."
  default     = "127.0.0.1" # Dummy default to prevent unintended access
}

variable "instance_count" {
  description = "Number of identical instances to deploy"
  default     = 1
}

variable "user_data" {
  description = "User Data (startup script) to run on VMs at first boot"
  default     = ""
}
