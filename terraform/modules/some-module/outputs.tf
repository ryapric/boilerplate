output "instance_ip" {
  value = aws_eip.main.public_ip
}
