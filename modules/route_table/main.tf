resource "aws_route_table" "public_route_table_frontend" {
  vpc_id = var.vpc_id_a
  route {
    cidr_block = var.internet_cidr
    gateway_id = var.internet_gateway_id_a
  }
  tags = {
    Name      = var.name_pub_rtb_frontend_tag
    Terraform = var.tf_tag
  }
}

resource "aws_route_table" "public_route_table_bastion" {
  vpc_id = var.vpc_id_b
  route {
    cidr_block = var.internet_cidr
    gateway_id = var.internet_gateway_id_b
  }
  tags = {
    Name      = "bastion route"
    Terraform = var.tf_tag
  }
}

resource "aws_route_table" "private_route_table_backend" {
  vpc_id = var.vpc_id_a

  route {
    # cidr_block = var.public_subnets_frontend["public_subnet_frontend_1"].cidr_block  
    cidr_block = var.internet_cidr
    nat_gateway_id = var.nat_gateway_id
  }
  tags = {
    Name      = var.name_priv_rtb_backend_tag
    Terraform = var.tf_tag
  }
}


resource "aws_route_table" "private_route_table_database" {
  vpc_id = var.vpc_id_a

  route {
    # cidr_block = var.public_subnets_frontend["public_subnet_frontend_2"].cidr_block 
    cidr_block = var.internet_cidr
    nat_gateway_id = var.nat_gateway_id
  }
  tags = {
    Name      = var.name_priv_rtb_database_tag
    Terraform = var.tf_tag
  }
}




resource "aws_route_table_association" "public_route_table_frontend_assoc" {
  depends_on     = [var.public_subnets_frontend]
  route_table_id = aws_route_table.public_route_table_frontend.id
  for_each       = var.public_subnets_frontend
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private_route_table_backend_assoc" {
  depends_on     = [var.private_subnets_backend]
  route_table_id = aws_route_table.private_route_table_backend.id
  for_each       = var.private_subnets_backend
  subnet_id      = each.value.id
}


resource "aws_route_table_association" "private_route_table_database_assoc" {
  depends_on     = [var.private_subnets_database]
  route_table_id = aws_route_table.private_route_table_database.id
  for_each       = var.private_subnets_database
  subnet_id      = each.value.id
}

# --- VPC Peering Connection ---
resource "aws_vpc_peering_connection" "peer" {
  vpc_id       = var.vpc_id_a
  peer_vpc_id  = var.vpc_id_b
  auto_accept  = true

  tags = {
    Name = "VPC-A-to-VPC-B"
  }
}

# --- VPC Peering Routes in VPC A ---
resource "aws_route" "vpc_a_to_b_public" {
  route_table_id            = aws_route_table.public_route_table_frontend.id
  destination_cidr_block    = var.vpc_cidr_b
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "vpc_a_to_b_backend" {
  route_table_id            = aws_route_table.private_route_table_backend.id
  destination_cidr_block    = var.vpc_cidr_b
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "vpc_a_to_b_database" {
  route_table_id            = aws_route_table.private_route_table_database.id
  destination_cidr_block    = var.vpc_cidr_b
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# --- VPC Peering Route in VPC B ---
resource "aws_route" "vpc_b_to_a" {
  route_table_id            = aws_route_table.public_route_table_bastion.id
  destination_cidr_block    = var.vpc_cidr_a
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
