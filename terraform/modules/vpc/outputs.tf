output "vpc_id" {
  description = "ID của VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Danh sách ID của Public Subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Danh sách ID của Private Subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID của Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID của Public Route Table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID của Private Route Table"
  value       = aws_route_table.private.id
}
