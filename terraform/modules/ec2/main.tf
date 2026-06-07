###############################################################################
# Module: EC2
# Tạo Public EC2 (có public IP) và Private EC2 (chỉ truy cập qua Public EC2)
###############################################################################

# ----- SSH Key Pair -----
resource "aws_key_pair" "this" {
  key_name   = "${var.project}-key"
  public_key = file(var.public_key_path)

  tags = var.tags
}

# ----- Public EC2 Instance -----
resource "aws_instance" "public" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(var.tags, {
    Name = "${var.project}-public-ec2"
    Role = "Bastion"
  })
}

# ----- Private EC2 Instance -----
resource "aws_instance" "private" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_sg_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = merge(var.tags, {
    Name = "${var.project}-private-ec2"
    Role = "App"
  })
}
