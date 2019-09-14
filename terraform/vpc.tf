resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    var.default_tags,
    {}
  )
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  
  cidr_block = "10.0.1.0/24"
  
  tags = merge(
    var.default_tags,
    {}
  )
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    # cidr_blocks = var.whitelisted_ips
    from_port   = 80
    to_port     = 80
  }

  # SSH access for deployment host
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.tf_host_ip}/32"]
    from_port   = 22
    to_port     = 22
  }

  # Terraform replaces default egress rules, so reinstate here
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {}
  )
}

resource "aws_eip" "app" {
  instance = aws_instance.app.id
  vpc      = true

  # Output IP to local file for SSH and app deployment
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > instance_ip.txt"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.default_tags,
    {}
  )
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = merge(
    var.default_tags,
    {}
  )
}

resource "aws_route_table_association" "rt-to-subnet-main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

output "app_ip" {
  value = aws_eip.app.public_ip
}
