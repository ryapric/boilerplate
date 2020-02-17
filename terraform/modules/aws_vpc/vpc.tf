# This config file creates all the pieces of an AWS VPC from scratch. You don't
# necessarily need this in real life (maybe you're using existing IDs for each),
# but this allows you to get started with this boilerplate subrepo quickly.

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

  # Ping access. ICMP is weird and doesn't use "ports" like other protocols do,
  # so from_port and to_port are 8 & 0, respectively
  # https://github.com/hashicorp/terraform/issues/1313#issuecomment-107619807
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8
    to_port     = 0
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
