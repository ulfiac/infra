output "public_route_table_id" {
  description = "The ID of the shared public route table"
  value       = aws_route_table.public.id
}

output "public_subnet_ids" {
  description = "Map of availability zone to public subnet ID"
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}
