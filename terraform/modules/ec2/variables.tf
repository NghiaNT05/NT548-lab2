variable "project" {
  type = string
}

variable "ami_id" {
  description = "AMI ID (Amazon Linux 2023 hoặc Ubuntu)"
  type        = string
  # Amazon Linux 2023 tại ap-southeast-1
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Loại EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_id" {
  description = "ID của Public Subnet để đặt Public EC2"
  type        = string
}

variable "private_subnet_id" {
  description = "ID của Private Subnet để đặt Private EC2"
  type        = string
}

variable "public_sg_id" {
  description = "Security Group ID cho Public EC2"
  type        = string
}

variable "private_sg_id" {
  description = "Security Group ID cho Private EC2"
  type        = string
}

variable "public_key_path" {
  description = "Đường dẫn tới file public key SSH (ví dụ: ~/.ssh/id_rsa.pub)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  type    = map(string)
  default = {}
}
