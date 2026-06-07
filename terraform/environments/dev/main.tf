###############################################################################
# Root module - Environment: dev
# Gọi tất cả các module con theo đúng thứ tự phụ thuộc
###############################################################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ── Bước 1: Tạo NAT Gateway trước (cần biết ID để truyền vào VPC module) ──
module "nat_gateway" {
  source = "../../modules/nat_gateway"

  project             = var.project
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  internet_gateway_id = module.vpc.internet_gateway_id
  tags                = local.common_tags

  # NAT GW phụ thuộc VPC tạo trước
  depends_on = [module.vpc]
}

# ── Bước 0: Tạo VPC (cần nat_gateway_id – dùng dependency ngược) ──
# Lưu ý: vpc module cần nat_gateway_id nên chúng ta dùng một biến tạm trống
# rồi apply 2 lần, HOẶC dùng cách sau (tách route ra ngoài module)

module "vpc" {
  source = "../../modules/vpc"

  project              = var.project
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = local.common_tags
}

resource "aws_route" "private_nat" {
  route_table_id         = module.vpc.private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.nat_gateway_id

  depends_on = [module.nat_gateway, module.vpc]
}

module "security_groups" {
  source = "../../modules/security_groups"

  project = var.project
  vpc_id  = module.vpc.vpc_id
  my_ip   = var.my_ip
  tags    = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  project           = var.project
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]
  public_sg_id      = module.security_groups.public_ec2_sg_id
  private_sg_id     = module.security_groups.private_ec2_sg_id
  public_key_path   = var.public_key_path
  tags              = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
