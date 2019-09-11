variable "region" {
  default = "us-east-1"
}

variable "default_tags" {
  type = "map"
  default = {
    "owner" = "ryapric@gmail.com"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
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
  type    = "string"
  default = ""
}

variable "app_instance_nametag" {
  type = "string"
  default = "terraform_instance_dev"
}
