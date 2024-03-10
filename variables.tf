#------------ VARIABLES FOR CONFIGURING AWS PROFILE -------------#

variable "profile_name" {
  type = string
  default = "iam_wordp"
}

variable "region_name" {
  type = string
  default = "us-east-2"
}

#------------ VARIABLES FOR VPC -------------#

variable "vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "vpc_tag_name" {
  type = string
  default = "vpc_custom"
}

#------------ VARIABLES FOR SUBNETS -------------#

variable "subnets" {
  type = map(string)
  default = {
    "us-east-2a" = "192.168.0.0/24"
    "us-east-2b" = "192.168.1.0/24"
  }
}

#------------ VARIABLES FOR PUBLIC SUBNET -------------#

variable "pub_subnet_az" {
  type = string
  default = "us-east-2a"
}

#------------ VARIABLES FOR PRIVATE SUBNET -------------#

variable "pri_subnet_az" {
  type = string
  default = "us-east-2b"
}

#------------ VARIABLES FOR GATEWAYS AND ELASTIC IP -------------#

variable "wordpress_db_name" {
  description = "WordPress DB Name"
  type        = string
  default     = "wordpress"
}

variable "db_host_name" {
  description = "WordPress DB hostname"
  type        = string
  default = "localhost"
}