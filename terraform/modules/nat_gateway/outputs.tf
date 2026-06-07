output "nat_gateway_id" {
  description = "ID của NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "elastic_ip" {
  description = "Elastic IP của NAT Gateway"
  value       = aws_eip.nat.public_ip
}
