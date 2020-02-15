variable "aws_region" {}

variable "default_tags" {
  type = map
}

variable "tf_host_ip" {
  description = ""
  # Dummy default to prevent unintended access
  default = "127.0.0.1"
}