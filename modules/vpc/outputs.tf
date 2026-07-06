output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_id" {
  value = [for s in aws_subnet.private : s.id]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "nat_eip" {
  value = aws_eip.nat.public_ip
}
