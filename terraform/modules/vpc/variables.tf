variable "project" {
  description = "Tên project, dùng làm prefix cho các resource"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block cho VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Danh sách CIDR cho các Public Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Danh sách CIDR cho các Private Subnet"
  type        = list(string)
  default     = ["10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Danh sách Availability Zones"
  type        = list(string)
  default     = ["ap-southeast-1a"]
}

variable "tags" {
  description = "Tags áp dụng cho mọi resource"
  type        = map(string)
  default     = {}
}
