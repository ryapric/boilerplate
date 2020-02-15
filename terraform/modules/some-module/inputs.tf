variable "aws_region" {
  description = ""
}

variable "default_tags" {
  description = ""
  type = map
}

variable "privkey_path" {
  default = "~/.ssh/id_rsa"
}

variable "pubkey_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "tf_host_ip" {
  description = ""
}
