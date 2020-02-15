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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]

  key_name = aws_key_pair.pubkey.key_name

  tags = merge(
    var.default_tags,
    {Name = "tf-created"},
    {}
  )
}
