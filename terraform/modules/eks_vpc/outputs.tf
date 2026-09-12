output "isolated_route_table_id" {
  description = "The ID of the shared isolated route table"
  value       = aws_route_table.isolated.id
}

output "isolated_subnet_ids" {
  description = "List of isolated subnet IDs"
  value       = [for az, subnet in aws_subnet.isolated : subnet.id]
}

output "isolated_subnet_ids_map" {
  description = "Map of availability zone to isolated subnet ID"
  value       = { for az, subnet in aws_subnet.isolated : az => subnet.id }
}

output "private_route_table_id" {
  description = "The ID of the shared private route table"
  value       = aws_route_table.private.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for az, subnet in aws_subnet.private : subnet.id]
}

output "private_subnet_ids_map" {
  description = "Map of availability zone to private subnet ID"
  value       = { for az, subnet in aws_subnet.private : az => subnet.id }
}

output "public_route_table_id" {
  description = "The ID of the shared public route table"
  value       = aws_route_table.public.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for az, subnet in aws_subnet.public : subnet.id]
}

output "public_subnet_ids_map" {
  description = "Map of availability zone to public subnet ID"
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}
