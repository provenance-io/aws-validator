resource "aws_security_group" "allow_personal_ssh" {
  name        = "demo_allow_personal_ssh"
  description = "Allow SSH access from a specific source ip"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.personal_cidr]
  }

  tags = {
    Name = "demo_allow_personal_ssh"
  }
}

resource "aws_security_group" "allow_internal_ssh" {
  name        = "demo_allow_internal_ssh"
  description = "Allow SSH access from a bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name = "demo_allow_internal_ssh"
  }
}

resource "aws_security_group" "allow_tmkms" {
  name        = "demo_allow_tmkms"
  description = "Allow tmkms port"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 26669
    to_port   = 26669
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 26669
    to_port   = 26669
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name = "demo_allow_tmkms"
  }
}

resource "aws_security_group" "allow_strict_external_cosmos" {
  name        = "demo_allow_strict_external_cosmos"
  description = "Allow internal nodes access to external cosmos nodes"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 26656
    to_port     = 26657
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_allow_strict_external_cosmos"
  }
}

resource "aws_security_group" "allow_outbound_internet_access" {
  name        = "demo_allow_outbound_internet_access"
  description = "Allow all outbound to the internet"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo_allow_outbound_internet_access"
  }
}
