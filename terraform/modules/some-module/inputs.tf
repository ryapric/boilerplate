variable "aws_region" {
  description = ""
}

variable "default_tags" {
  description = ""
  type = map
}

variable "privkey_path" {
  type    = "string"
  default = "~/.ssh/id_rsa"
}

variable "pubkey_path" {
  type    = "string"
  default = "~/.ssh/id_rsa.pub"
}

variable "tf_host_ip" {
  description = ""
}
