output "internet_gateway_id_a" {
  value = aws_internet_gateway.internet_gateway_a.id
}

output "internet_gateway_id_b" {
  value = aws_internet_gateway.internet_gateway_b.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}