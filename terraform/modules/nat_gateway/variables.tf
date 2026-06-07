variable "project" {
  type = string
}

variable "public_subnet_id" {
  description = "ID của Public Subnet để đặt NAT Gateway"
  type        = string
}

variable "internet_gateway_id" {
  description = "Dùng để đảm bảo IGW tạo trước NAT GW"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
