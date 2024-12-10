output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.vpc-tr.id
}

output "public_subnets_id" {
  description = "ID of the created subnets"
  value       = aws_subnet.public-subnets.*.id
}

output "private_subnets_id" {
  
  description = "ID of the created subnets"
  value       = aws_subnet.private-subnets.*.id
}