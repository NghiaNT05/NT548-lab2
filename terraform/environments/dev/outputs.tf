output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "nat_gateway_ip" {
  value = module.nat_gateway.elastic_ip
}

output "public_ec2_public_ip" {
  description = "Dùng IP này để SSH vào Public EC2 (Bastion)"
  value       = module.ec2.public_instance_public_ip
}

output "private_ec2_private_ip" {
  description = "Dùng IP này để SSH từ Bastion sang Private EC2"
  value       = module.ec2.private_instance_private_ip
}
