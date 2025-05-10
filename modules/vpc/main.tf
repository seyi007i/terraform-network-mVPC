
resource "aws_vpc" "vpc_a" {
  cidr_block = var.vpc_cidr_a

  tags = {
    Name        = var.vpc_name_a
    Environment =  var.environment
    Terraform   = var.tf_tag
  }
}

resource "aws_vpc" "vpc_b" {
  cidr_block = var.vpc_cidr_b

  tags = {
    Name        = var.vpc_name_b
    Environment =  var.environment
    Terraform   = var.tf_tag
  }
}
