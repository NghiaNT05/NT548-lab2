variable "project" {
  type = string
}

variable "public_subnet_id" {
  description = "ID của Public Subnet để đặt NAT Gateway"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
