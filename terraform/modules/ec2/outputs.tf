output "public_instance_id" {
  value = aws_instance.public.id
}

output "public_instance_public_ip" {
  description = "Public IP của Public EC2 (Bastion)"
  value       = aws_instance.public.public_ip
}

output "private_instance_id" {
  value = aws_instance.private.id
}

output "private_instance_private_ip" {
  description = "Private IP của Private EC2"
  value       = aws_instance.private.private_ip
}
