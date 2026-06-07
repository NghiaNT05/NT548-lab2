variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Tên project"
  type        = string
  default     = "nt548-lab2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a"]
}

variable "my_ip" {
  description = "IP của bạn (không kèm /32). Kiểm tra tại https://checkip.amazonaws.com"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI tại us-east-1"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "public_key_path" {
  description = "Đường dẫn file public key SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
