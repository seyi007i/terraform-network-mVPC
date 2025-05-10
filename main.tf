data "aws_region" "current" {}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_a = "10.0.0.0/16" 
  vpc_cidr_b = "10.1.0.0/16"  
}

module "subnet" {
  source   = "./modules/subnet"
  vpc_id_a   = module.vpc.vpc_id_a 
  vpc_id_b  =module.vpc.vpc_id_b
  vpc_cidr_public_subnets_frontend= ["10.0.160.0/20", "10.0.176.0/20" ] 
  vpc_cidr_private_subnets_backend= ["10.0.192.0/20", "10.0.208.0/20" ] 
  vpc_cidr_private_subnets_database=["10.0.224.0/20", "10.0.240.0/20" ] 
  vpc_cidr_public_subnets_bastion= "10.1.160.0/20"

}

module "gateways" {
  source = "./modules/gateways"
  vpc_id_a = module.vpc.vpc_id_a
  vpc_id_b = module.vpc.vpc_id_b 
  
  public_subnets_frontend = module.subnet.public_subnets_frontend
}

module "route_tables" {
  source = "./modules/route_table"
  vpc_id_a = module.vpc.vpc_id_a 
  vpc_id_b = module.vpc.vpc_id_b
  vpc_cidr_a = module.vpc.vpc_cidr_a
  vpc_cidr_b = module.vpc.vpc_cidr_b
  public_subnets_frontend = module.subnet.public_subnets_frontend
  private_subnets_backend = module.subnet.private_subnets_backend
  private_subnets_database = module.subnet.private_subnets_database
  public_subnets_bastion = module.subnet.public_subnets_bastion
  internet_gateway_id_a = module.gateways.internet_gateway_id_a
  internet_gateway_id_b = module.gateways.internet_gateway_id_b
  nat_gateway_id = module.gateways.nat_gateway_id

}

module "keys" {
  source = "./modules/keys"
}


module "sgs" {
  source = "./modules/sgs"
  vpc_id_a = module.vpc.vpc_id_a  
  vpc_id_b = module.vpc.vpc_id_b
  public_subnets_frontend = module.subnet.public_subnets_frontend
  private_subnets_backend = module.subnet.private_subnets_backend
  
}



module "ec2" {
  source = "./modules/ec2"
  public_subnets_frontend = module.subnet.public_subnets_frontend
  private_subnets_backend = module.subnet.private_subnets_backend
  public_subnets_bastion = module.subnet.public_subnets_bastion
  public_subnets_frontend_sg = module.sgs.frontend_sg_id
  private_subnets_backend_sg = module.sgs.backend_sg_id
  public_subnets_bastion_sg = module.sgs.bastion_sg_id
  key_name = module.keys.key_name

}


module "dbs" {
  source = "./modules/dbs"
  private_subnets_database = module.subnet.private_subnets_database
  private_subnets_database_sg = module.sgs.db_sg_id
  
}



