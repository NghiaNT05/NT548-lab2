variable "project" {
  type = string
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "my_ip" {
  description = "IP của người dùng (không kèm /32), dùng để whitelist SSH vào Public EC2"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
