provider "aws" {
  region  = var.region_name
}

module "key_gen" {
   source = "./key"
   key_name = "wp_key"
}

module "vpc_gen" {
   source = "./vpc"
   vpc_cidr = var.vpc_cidr
   vpc_tag_name = var.vpc_tag_name
}

module "public_subnet" {
   source = "./subnet"
   subnet_az = var.pub_subnet_az
   cidr = "${var.subnets["${var.pub_subnet_az}"]}"
   map_public_ip = "true"
   vpc_id = module.vpc_gen.vpc.id
   name_tag = "public_subnet"
}

module "gateways_eip" {
  source = "./gateways"
  vpc_id = module.vpc_gen.vpc.id
  igw_name = "custom_igw"
  natgw_eip_name = "custom_natgw_eip"
  public_subnet_id = module.public_subnet.subnet_id
  natgw_name = "custom_natgw"
}

module "igw_route_table" {
  source = "./route_tables"
  vpc_id = module.vpc_gen.vpc.id
  cidr_block = "0.0.0.0/0"
  igw_id = module.gateways_eip.igw_id
  pub_subnet_id = module.public_subnet.subnet_id
}

module "sgs" {
  source = "./sg"
  vpc_id = module.vpc_gen.vpc.id
  vpc_cidr = module.vpc_gen.vpc.cidr_block
}

module "wp_inst" {
  source = "./ec2"
  ami = "ami-03698ab9d73a24523" # Debian
  inst_type = "t2.micro"
  key_name = module.key_gen.key_name
  sg_id = module.sgs.wp_sg_id
  subnet_id = module.public_subnet.subnet_id
  db_host_name = var.db_host_name
  wordpress_db_name = var.wordpress_db_name
}

output "wp_inst_ip" {
  value = module.wp_inst.db.public_ip
}
