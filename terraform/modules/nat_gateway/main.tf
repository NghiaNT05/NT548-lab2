###############################################################################
# Module: NAT Gateway
# Tạo Elastic IP và NAT Gateway trong Public Subnet
###############################################################################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_id

  tags = merge(var.tags, {
    Name = "${var.project}-nat-gw"
  })

  depends_on = [var.internet_gateway_id]
}
