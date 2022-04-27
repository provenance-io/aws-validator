resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "demo_main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo_main_gateway"
  }
}

resource "aws_eip" "nat_a" {
  vpc = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_nat_gateway" "main_a_nat" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.main_a_public.id

  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "main_a_private" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.0.0/24"

  tags = {
    Name = "demo_main_a_private"
  }
}

resource "aws_subnet" "main_a_public" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-west-2a"
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo_main_a_public"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "demo_main_route_table"
  }
}

resource "aws_route_table_association" "main_a_public_route_table" {
  subnet_id      = aws_subnet.main_a_public.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_a_nat.id
  }

  tags = {
    Name = "demo_private_route_table"
  }
}

resource "aws_route_table_association" "main_a_private_route_table" {
  subnet_id      = aws_subnet.main_a_private.id
  route_table_id = aws_route_table.private_route_table.id
}
