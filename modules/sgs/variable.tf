variable "vpc_id_a" {
    description = "VPC ID from the VPC module"
    type        = string
}

variable "vpc_id_b" {
    description = "VPC ID from the VPC module"
    type        = string
}

variable "public_subnets_frontend" {
    description = "Frontend subnet"

}

variable "private_subnets_backend" {
    description = "Backend subnet"

}


variable "tf_tag" {
    type = bool
    default = true         
    description = "Terraform identifier"
  
}