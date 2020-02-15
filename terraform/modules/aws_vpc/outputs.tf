output "subnet_id" {
  value = aws_subnet.main.id
}

output "security_group_ids" {
  value = [aws_security_group.main.id]
}
