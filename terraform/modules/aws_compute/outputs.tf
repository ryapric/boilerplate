output "instance_ips" {
  # This can also be an EIP, but if you're just foolin' around, you can just use
  # the dynamic public IP attached to the instance. If an EIP, you can use:
  # value = aws_eip.main.public_ip
  value = aws_instance.main.*.public_ip
}
