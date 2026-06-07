###############################################################################
# Module: VPC
# Tạo VPC, Public Subnet, Private Subnet, Internet Gateway, Default Security Group
###############################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.project}-vpc"
  })
}

# ----- Internet Gateway -----
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project}-igw"
  })
}

# ----- Public Subnet -----
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.project}-public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

# ----- Private Subnet -----
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name = "${var.project}-private-subnet-${count.index + 1}"
    Type = "Private"
  })
}

# ----- Public Route Table -----
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.project}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ----- Private Route Table (sẽ dùng NAT GW từ module nat_gateway) -----
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project}-private-rt"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# ----- Default Security Group -----
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project}-default-sg"
  })
}
