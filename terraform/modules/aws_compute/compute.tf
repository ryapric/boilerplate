resource "aws_key_pair" "pubkey" {
  key_name = "terraform_ryanprice_${var.aws_region}"
  public_key = file(pathexpand(var.pubkey_path))
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

resource "aws_instance" "main" {
  # Can optionally pass a `count` value to supported resources
  count = var.instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  user_data = var.user_data

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  
  associate_public_ip_address = true

  key_name = aws_key_pair.pubkey.key_name

  tags = merge(
    var.default_tags,
    { Name = var.instance_nametag },
    {}
  )
}
