variable "vpc_name_a" {
  type    = string
  default = "3_Tier_vpc_a"     
  description = "vpc name"
}

variable "vpc_name_b" {
  type    = string
  default = "3_Tier_vpc_b"     
  description = "vpc name"
}

variable "vpc_cidr_a" {
  type    = string
  # default = "10.0.0.0/16"     
  description = "vpc cidr"
}

variable "vpc_cidr_b" {
  type    = string
  # default = "10.1.0.0/16"     
  description = "vpc cidr"
}

variable    "environment" {
    type= string
    default= "demo environment"           
    description = "Environment of deployment"
}

variable "tf_tag" {
    type = bool
    default = true         #
    description = "Terraform identifier"
  
}