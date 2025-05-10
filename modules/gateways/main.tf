
resource "aws_internet_gateway" "internet_gateway_a" {
  vpc_id = var.vpc_id_a
  tags = {
    Name = var.igw_tag
  }
}

resource "aws_internet_gateway" "internet_gateway_b" {
  vpc_id = var.vpc_id_b
  tags = {
    Name = var.igw_tag
  }
}


resource "aws_eip" "nat_gateway_eip" {
  domain     = var.nat_domain
  depends_on = [aws_internet_gateway.internet_gateway_a]
  tags = {
    Name = var.nat_eip_tag
  }
}


resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [var.public_subnets_frontend]
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = var.public_subnets_frontend["public_subnet_frontend_2"].id
  tags = {
    Name = var.nat_igw_tag
  }
}