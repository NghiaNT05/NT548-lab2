###############################################################################
# Module: Security Groups
# Public EC2 SG: chỉ cho phép SSH từ IP cụ thể
# Private EC2 SG: chỉ cho phép SSH từ Public EC2 SG
###############################################################################

# ----- Public EC2 Security Group -----
resource "aws_security_group" "public_ec2" {
  name        = "${var.project}-public-ec2-sg"
  description = "Security Group cho Public EC2: cho phep SSH tu IP cu the"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project}-public-ec2-sg"
  })
}

# ----- Private EC2 Security Group -----
resource "aws_security_group" "private_ec2" {
  name        = "${var.project}-private-ec2-sg"
  description = "Security Group cho Private EC2: chi cho phep SSH tu Public EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from Public EC2 SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project}-private-ec2-sg"
  })
}
