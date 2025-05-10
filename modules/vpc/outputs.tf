
output "vpc_id_a" {
  value = aws_vpc.vpc_a.id
}

output "vpc_cidr_a" {
  value = aws_vpc.vpc_a.cidr_block
}

output "vpc_id_b" {
  value = aws_vpc.vpc_b.id
}

output "vpc_cidr_b" {
  value = aws_vpc.vpc_b.cidr_block
}