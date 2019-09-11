provider "aws" {
  region = var.region
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = aws_subnet.main.id

  key_name = aws_key_pair.pubkey.key_name

  tags = merge(
    var.default_tags,
    {Name = var.app_instance_nametag},
    {}
  )
}

resource "aws_key_pair" "pubkey" {
  key_name = "terraform_${var.region}"
  public_key = file(pathexpand(var.pubkey_path))
}
